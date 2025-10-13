#!/usr/bin/env bash
set -euo pipefail
echo "🔧 TriHelix Self-Heal starting…"

mkdir -p .helix/logs .helix

# 1) STATE rebuild (if missing)
if [ ! -f .helix/state.json ]; then
  echo "• Reconstructing .helix/state.json from logs…"
  last_log=$(find .helix/logs -maxdepth 1 -type f -name 'loop-*.json' -printf '%T@ %p\n' 2>/dev/null | sort -nr | head -n1 | awk '{print $2}')
  iter=$(find .helix/logs -maxdepth 1 -type f -name 'loop-*.json' 2>/dev/null | wc -l | tr -d ' ')
  if [ -n "${last_log:-}" ] && [ -f "$last_log" ]; then
    started=$(jq -r '.started_at // now|todate' "$last_log" 2>/dev/null || date -Iseconds)
    finished=$(jq -r '.finished_at // now|todate' "$last_log" 2>/dev/null || date -Iseconds)
    status=$(jq -r '.status // "ok"' "$last_log" 2>/dev/null || echo ok)
  else
    started=$(date -Iseconds); finished="$started"; status="not-run"; iter=0
  fi
  jq -n --arg phase "Conductor" --arg s "$started" --arg f "$finished" --arg status "$status" --argjson it "$iter" \
    '{phase:$phase, iteration:$it, last_loop:{status:$status, started_at:$s, finished_at:$f, artifacts:{}}}' \
    > .helix/state.json
  echo "✅ STATE rebuilt: .helix/state.json (iteration=$iter, status=$status)"
else
  echo "• STATE exists; skip rebuild."
fi

# 2) METRICS
bash scripts/metrics.sh

# 3) POLICY
if bash scripts/policy-guard.sh; then
  echo "✅ POLICY: PASS"
else
  echo "❌ POLICY: FAIL"; exit 3
fi

echo "🎉 Self-Heal complete."
