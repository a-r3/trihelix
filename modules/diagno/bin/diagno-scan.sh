#!/usr/bin/env bash
set -euo pipefail
OUT_DIR="modules/diagno/out"; REPORT_DIR="modules/diagno/reports"
mkdir -p "$OUT_DIR" "$REPORT_DIR"
ts=$(date -Iseconds)
cat > "$OUT_DIR/insights.json" <<JSON
{"ts":"$ts","risk":"low","quick_wins":["keep logs append-only"],"strategic":["introduce module tests"]}
JSON
cat > "$REPORT_DIR/report.json" <<JSON
{"ts":"$ts","status":"ok","details":"stub health check"}
JSON
echo "🩺 Diagno: wrote insights → $OUT_DIR/insights.json and $REPORT_DIR/report.json"
