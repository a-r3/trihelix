#!/usr/bin/env bash
set -euo pipefail
LOGS_DIR=".helix/logs"
OUT_JSON=".helix/metrics.json"
OUT_MD="docs/METRICS.md"
mkdir -p "$(dirname "$OUT_JSON")" "docs"
loops=$(ls "$LOGS_DIR"/loop-*.json 2>/dev/null | wc -l | tr -d ' ')
last_ts=$(jq -r '.finished_at' $(ls -1 "$LOGS_DIR"/loop-*.json 2>/dev/null | tail -n 1) 2>/dev/null || echo "N/A")
jq -s '{
  total_loops: length,
  last_finished_at: (.[-1].finished_at // null),
  ok_count: map(select(.status=="ok"))|length
}' "$LOGS_DIR"/loop-*.json 2>/dev/null > "$OUT_JSON" || echo '{"total_loops":0,"ok_count":0}' > "$OUT_JSON"
cat > "$OUT_MD" <<MD
# Metrics

- Total loops: ${loops}
- Last finished at: ${last_ts}

\`\`\`json
$(cat "$OUT_JSON")
\`\`\`
MD
echo "✅ Metrics updated → $OUT_JSON, $OUT_MD"
