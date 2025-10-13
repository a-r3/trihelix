#!/usr/bin/env bash
set -euo pipefail
SRC="docs/TASKS.md"
OUT="modules/diagno/reports/report.json"
tmp="$(mktemp)"

open=$(sed -n '/BEGIN:EP_IMPORT/,/END:EP_IMPORT/p' "$SRC" | grep -c '^- \[ \]')
done=$(grep -c '^- \[x\]' "$SRC" || true)

jq --argjson open "$open" --argjson done "$done" \
  '.phase_coverage = {open:$open, done:$done}' "$OUT" > "$tmp" && mv "$tmp" "$OUT"
echo "✅ Diagno coverage updated (open=$open, done=$done)"
