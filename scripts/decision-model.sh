#!/usr/bin/env bash
set -euo pipefail
I=".helix/insights.json"; H=".helix/health.json"; OUT=".helix/decision.json"
jq -n --argjson ins "$(cat "$I" 2>/dev/null || echo '{}')" \
      --argjson h   "$(cat "$H" 2>/dev/null || echo '{}')" '
  def pick_action:
    if ($h.score//0) >= 85 then
      {action:"harden", goals:["policy guard hardening","module tests","coverage +5%"]}
    else
      {action:"stabilize", goals:["fix quick wins","stabilize bus","increase observability"]}
    end;
  {ts: (now|todate), decision: pick_action, inputs:{health:$h, insights:$ins}}
' > "$OUT"
echo "✅ decision → $OUT"
