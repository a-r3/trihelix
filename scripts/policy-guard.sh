#!/usr/bin/env bash
set -euo pipefail
P=docs/POLICY.yaml
H=.helix/health.json
M=.helix/metrics.json
[ -f "$P" ] || { echo "No $P"; exit 2; }

ok=1
# check 1: metrics exists
if ! [ -f "$M" ]; then
  echo "❌ policy: metrics missing ($M)"; ok=0
fi

# check 2: health exists & >= 70
if [ -f "$H" ]; then
  hs=$(jq -r '.score|tonumber' "$H" 2>/dev/null || echo 0)
  if [ "$hs" -lt 70 ]; then
    echo "❌ policy: health<70 (got $hs)"; ok=0
  fi
else
  echo "❌ policy: health missing ($H)"; ok=0
fi

if [ $ok -eq 1 ]; then
  echo "✅ policy guard: PASS"
else
  echo "❌ policy guard: FAIL"
  exit 3
fi
