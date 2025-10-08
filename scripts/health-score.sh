#!/usr/bin/env bash
set -euo pipefail
IN="modules/diagno/reports/report.json"
OUT=".helix/health.json"
mkdir -p .helix
# Sadə skorlama: status=ok → 90, risk=low → +10
status=$(jq -r '.status? // "ok"' "$IN" 2>/dev/null || echo ok)
risk=$(jq -r '.risk? // "low"' modules/diagno/out/insights.json 2>/dev/null || echo low)
score=80
[ "$status" = "ok" ] && score=$((score+10))
[ "$risk" = "low" ] && score=$((score+10))
ts=$(date -Iseconds)
jq -n --arg ts "$ts" --arg status "$status" --arg risk "$risk" --argjson score $score \
  '{ts:$ts,status:$status,risk:$risk,score:$score}' > "$OUT"
echo "✅ Health score: $score → $OUT"
