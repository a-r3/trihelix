#!/usr/bin/env bash
set -euo pipefail
H=".helix/health.json"
I="modules/diagno/out/insights.json"
R="docs/ROADMAP.md"
PLAN="modules/atlas/plans/plan.json"
mkdir -p modules/atlas/plans

score=$(jq -r '.score' "$H" 2>/dev/null || echo 0)
risk=$(jq -r '.risk' "$I" 2>/dev/null || echo "unknown")
ts=$(date -Iseconds)
sprint="S-$(date +%Y%m%d)"

echo "## Roadmap Update @ $ts ($sprint)" >> "$R"
if [ "$score" -ge 85 ]; then
  echo "- Health good (score=$score). Move to policy hardening & tests." >> "$R"
  goals='["policy guard hardening","module tests","coverage +5%"]'
else
  echo "- Health moderate (score=$score, risk=$risk). Prioritize quick wins." >> "$R"
  goals='["fix quick wins","stabilize bus","increase observability"]'
fi

# NOTE: goals artıq JSON-dur → --argjson ilə gəlir → fromjson YOXDUR
jq --arg ts "$ts" --arg sprint "$sprint" --argjson goals "$goals" \
  '.ts=$ts | .sprint=$sprint | .goals=$goals' \
  "$PLAN" > "${PLAN}.tmp" && mv "${PLAN}.tmp" "$PLAN"

echo "✅ Atlas adapted roadmap → $R and updated plan.json"
