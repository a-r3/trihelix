#!/usr/bin/env bash
set -euo pipefail
F="docs/TASKS.md"
tmp="$(mktemp)"
awk '
  BEGIN{inM=0; inP=0; m=0; p=0}
  /BEGIN:EP_IMPORT_META/ {inM=1}
  /END:EP_IMPORT_META/   {inM=0}
  /BEGIN:EP_IMPORT_PROJECT/ {inP=1}
  /END:EP_IMPORT_PROJECT/   {inP=0}
  {
    if(inM && $0 ~ /^- \[ \] / && m<3){ sub(/\[ \]/,"[x]"); m++ }
    if(inP && $0 ~ /^- \[ \] / && p<2){ sub(/\[ \]/,"[x]"); p++ }
    print
  }
' "$F" > "$tmp" && mv "$tmp" "$F"
echo "✅ Marked: META x3, PROJECT x2 as done"
