#!/usr/bin/env bash
set -euo pipefail
P=docs/POLICY.yaml
H=.helix/health.json
M=.helix/metrics.json
ok=1

# helper: hours since file modified
age_hours() {
  f="$1"; [ -f "$f" ] || { echo 1e9; return; }
  now=$(date +%s); mt=$(stat -c %Y "$f" 2>/dev/null || echo $now)
  echo $(( (now-mt)/3600 ))
}

# 1) metrics
if ! [ -f "$M" ]; then echo "❌ policy: metrics missing ($M)"; ok=0
else
  ah=$(age_hours "$M")
  if [ "$ah" -gt 24 ]; then echo "❌ policy: metrics too old (${ah}h)"; ok=0; fi
fi

# 2) health (on main enforce 85+)
branch="${GITHUB_REF_NAME:-$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo dev)}"
if [ -f "$H" ]; then
  hs=$(jq -r '.score|tonumber' "$H" 2>/dev/null || echo 0)
  min=70
  [ "$branch" = "main" ] && min=85
  if [ "$hs" -lt "$min" ]; then echo "❌ policy: health<$min (got $hs) on $branch"; ok=0; fi
else
  echo "❌ policy: health missing ($H)"; ok=0
fi

# 3) evolution baseline
if ! bash scripts/evolution-guard.sh >/dev/null; then
  echo "❌ policy: evolution baseline check failed"; ok=0
fi

# 4) tasks non-empty when HARDEN
if jq -e '.decision.action=="harden"' ./.helix/decision.json >/dev/null 2>&1; then
  if ! grep -q '\[ \]' docs/TASKS.md; then
    echo "❌ policy: harden selected but no open tasks"; ok=0
  fi
fi

[ $ok -eq 1 ] && echo "✅ policy guard: PASS" || { echo "❌ policy guard: FAIL"; exit 3; }
