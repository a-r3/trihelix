#!/usr/bin/env bash
set -euo pipefail

echo "🔧 TriHelix Self-Heal starting…"

# 1) STATE: .helix/state.json bərpası
mkdir -p .helix/logs
if [ ! -f .helix/state.json ]; then
  echo "• Reconstructing .helix/state.json from logs…"
  last_log=$(ls -1 .helix/logs/loop-*.json 2>/dev/null | tail -n 1 || true)
  iter=$(ls -1 .helix/logs/loop-*.json 2>/dev/null | wc -l | tr -d ' ')
  if [ -n "$last_log" ]; then
    started=$(jq -r '.started_at // now|todate' "$last_log" 2>/dev/null || date -Iseconds)
    finished=$(jq -r '.finished_at // now|todate' "$last_log" 2>/dev/null || date -Iseconds)
    status=$(jq -r '.status // "ok"' "$last_log" 2>/dev/null || echo ok)
  else
    started=$(date -Iseconds); finished=$started; status="not-run"
    iter=0
  fi
  jq -n --arg phase "Conductor" --arg s "$started" --arg f "$finished" --arg status "$status" --argjson it $iter \
    '{phase:$phase, iteration:$it, last_loop:{status:$status, started_at:$s, finished_at:$f, artifacts:{}}}' \
    > .helix/state.json
  echo "✅ STATE rebuilt: .helix/state.json (iteration=$iter, status=$status)"
else
  echo "• STATE exists; skip rebuild."
fi

# 2) METRICS: yenilə
if [ -x scripts/metrics.sh ]; then
  bash scripts/metrics.sh
else
  echo "⚠️ scripts/metrics.sh tapılmadı"
fi

# 3) POLICY: yoxla
if bash scripts/policy-guard.sh; then
  echo "✅ POLICY: PASS"
else
  echo "❌ POLICY: FAIL"
  exit 3
fi

echo "🎉 Self-Heal complete."
