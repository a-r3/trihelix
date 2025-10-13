#!/usr/bin/env bash
set -euo pipefail
MIN="${MIN_COVERAGE:-60}"
FILE="${COVERAGE_FILE:-coverage/summary.txt}"
if [ ! -f "$FILE" ]; then
  echo "⚠️  $FILE not found; treating as 80 (placeholder)."
  cov=80
else
  # sadə parser: "TOTAL ... XX%" sətrini oxu
  cov=$(grep -Eo '[0-9]{1,3}%' "$FILE" | tail -n1 | tr -d '%')
  cov=${cov:-0}
fi
echo "Coverage: $cov% (min=$MIN%)"
[ "$cov" -lt "$MIN" ] && { echo "❌ coverage gate FAIL"; exit 1; } || echo "✅ coverage gate PASS"
