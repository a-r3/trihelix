#!/usr/bin/env bash
set -euo pipefail
NEW="${1:-}"
[ -n "$NEW" ] || { echo "Usage: $0 <new-version>"; exit 2; }
file="CONTEXT.yaml"
tmp="$(mktemp)"
awk -v v="$NEW" '
/^version:/ { sub($2, v); print; next } { print }
' "$file" > "$tmp" && mv "$tmp" "$file"
echo "✅ Set version: $NEW in $file"
