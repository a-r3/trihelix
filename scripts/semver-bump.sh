#!/usr/bin/env bash
set -euo pipefail
# Usage: ./scripts/semver-bump.sh [major|minor|patch]
KIND="${1:-patch}"
FILE="CONTEXT.yaml"
cur=$(awk '/^version:/{print $2; exit}' "$FILE")
IFS='.' read -r MA MI PA <<<"${cur:-0.0.0}"
case "$KIND" in
  major) MA=$((MA+1)); MI=0; PA=0;;
  minor) MI=$((MI+1)); PA=0;;
  patch) PA=$((PA+1));;
  *) echo "Use: major|minor|patch"; exit 2;;
esac
new="${MA}.${MI}.${PA}"
tmp=$(mktemp)
awk -v v="$new" '/^version:/{sub($2,v)}1' "$FILE" > "$tmp" && mv "$tmp" "$FILE"
echo "$new"
