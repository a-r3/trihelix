#!/usr/bin/env bash
set -euo pipefail
source scripts/safe-mode.sh

OUT="modules/diagno/out/insights.json"
REP="modules/diagno/reports/report.json"
mkdir -p "$(dirname "$OUT")" "$(dirname "$REP")"

ts=$(date -Iseconds)
cat > "$OUT" <<JSON
{"ts":"$ts","risk":"low","quick_wins":["keep logs append-only"],"strategic":["introduce module tests"]}
JSON

cat > "$REP" <<JSON
{"status":"ok","ts":"$ts"}
JSON

echo "✅ Diagno: wrote insights → $OUT and report → $REP"
[ "${SAFE_MODE}" = "1" ] && echo "🛡️  (Safe Mode: meta-only write allowed)"
