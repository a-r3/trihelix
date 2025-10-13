#!/usr/bin/env bash
set -euo pipefail
TASKS="docs/TASKS.md"
DONE="docs/TASKS_DONE.md"
TMP="$(mktemp)"

mkdir -p docs
[ -f "$TASKS" ] || { echo "# Tasks" > "$TASKS"; }

ts=$(date -Iseconds)
echo "🗂️  Task sync @ $ts"

if [ ! -f "$DONE" ]; then
  cat > "$DONE" <<MD
# Tasks — Done Archive

Arxivlənmiş tamamlanmış işlər. Hər sync zamanı əlavə olunur.

MD
fi

completed=""
while IFS= read -r line; do
  if [[ "$line" =~ ^[[:space:]]*-\ \[x\]\  ]]; then
    completed+="$line"$'\n'
    continue
  fi
  echo "$line" >> "$TMP"
done < "$TASKS"

mv "$TMP" "$TASKS"

if [ -n "$completed" ]; then
  {
    echo "## $ts"
    echo "$completed"
    echo
  } >> "$DONE"
  echo "✅ Archived completed tasks → $DONE"
else
  echo "ℹ️  No completed tasks to archive."
fi
