#!/usr/bin/env bash
set -euo pipefail
SRC="docs/TASKS.md"
PLAN="modules/atlas/plans/plan.json"
tmp="$(mktemp)"

# EP_IMPORT blokunu çıxar
blk="$(sed -n '/BEGIN:EP_IMPORT/,/END:EP_IMPORT/p' "$SRC" || true)"
# maddələri çıxar
items="$(printf "%s\n" "$blk" | sed -n 's/^- \[ \] (.*) //p')"

jq --argjson arr "$(printf '%s\n' "$items" | jq -R . | jq -s .)" \
  '.ep_tasks = $arr' "$PLAN" > "$tmp" && mv "$tmp" "$PLAN"

echo "✅ Atlas plan enriched with ep_tasks ($(printf "%s\n" "$items" | wc -l | tr -d " "))"
