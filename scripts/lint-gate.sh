#!/usr/bin/env bash
set -euo pipefail
warn=0
# Bash sintaks yoxlaması
find scripts -type f -name "*.sh" -print0 | xargs -0 -I{} bash -n {} || { echo "❌ bash -n failed"; exit 2; }
# shellcheck varsa, işlət (opsional)
if command -v shellcheck >/dev/null 2>&1; then
  shellcheck -x scripts/*.sh || { echo "❌ shellcheck issues"; exit 3; }
else
  echo "⚠️  shellcheck not installed; skipping."
  warn=1
fi
# Markdown lint (opsional)
if command -v markdownlint >/dev/null 2>&1; then
  markdownlint docs || { echo "❌ markdownlint issues"; exit 4; }
else
  echo "⚠️  markdownlint not installed; skipping."
  warn=1
fi
echo "✅ lint gate pass (warn=$warn)"
