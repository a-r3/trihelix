#!/usr/bin/env bash
set -euo pipefail
LOGS_DIR=".helix/logs"
OUT_JSON=".helix/metrics.json"
OUT_MD="docs/METRICS.md"
mkdir -p "$(dirname "$OUT_JSON")" "docs"

# Loop count
loops=$(find "$LOGS_DIR" -maxdepth 1 -type f -name 'loop-*.json' 2>/dev/null | wc -l | tr -d ' ')

# Last finished_at (if exists)
last_log=$(find "$LOGS_DIR" -maxdepth 1 -type f -name 'loop-*.json' -printf '%T@ %p\n' 2>/dev/null | sort -nr | head -n1 | awk '{print $2}')
last_ts="N/A"
if [ -n "${last_log:-}" ] && [ -f "$last_log" ]; then
  last_ts=$(jq -r '.finished_at' "$last_log" 2>/dev/null || echo "N/A")
fi

# Aggregate with jq if any logs, else zeroed
if [ "$loops" -gt 0 ]; then
  jq -s '{
    total_loops: length,
    last_finished_at: (.[-1].finished_at // null),
    ok_count: map(select(.status=="ok"))|length
  }' "$LOGS_DIR"/loop-*.json > "$OUT_JSON" 2>/dev/null || echo '{"total_loops":0,"ok_count":0}' > "$OUT_JSON"
else
  echo '{"total_loops":0,"ok_count":0}' > "$OUT_JSON"
fi

cat > "$OUT_MD" <<MD
# Metrics

- Total loops: ${loops}
- Last finished at: ${last_ts}

\`\`\`json
$(cat "$OUT_JSON")
\`\`\`
MD
echo "✅ Metrics updated → $OUT_JSON, $OUT_MD"
