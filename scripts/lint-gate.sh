#!/usr/bin/env bash
set -euo pipefail

echo "🔎 Lint Gate running…"

# Bash sintaks yoxlaması (hamı üçün)
find scripts -type f -name "*.sh" -print0 | xargs -0 -I{} bash -n {}

# ShellCheck varsa — yalnız ERROR səviyyəsində kəs (warning/info icazəli)
if command -v shellcheck >/dev/null 2>&1; then
  # -S error → yalnız ERROR-lar non-zero çıxış verir
  shellcheck -S error -x scripts/*.sh
else
  echo "ℹ️  shellcheck is not installed; skipping."
fi

# Markdown lint (opsional)
if command -v markdownlint >/dev/null 2>&1; then
  markdownlint docs
else
  echo "ℹ️  markdownlint not installed; skipping."
fi

echo "✅ lint gate pass"
