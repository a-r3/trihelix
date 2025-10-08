#!/usr/bin/env bash
set -euo pipefail

REPO_NAME="${1:-trihelix}"
VISIBILITY="${2:-private}"   # private|public|internal
DEFAULT_BRANCH="${DEFAULT_BRANCH:-main}"

echo "🔧 Initializing git repository…"
git init -b "$DEFAULT_BRANCH"
git add -A
git commit -m "chore(init): TriHelix AI-native scaffold"

if command -v gh >/dev/null 2>&1; then
  echo "🌐 Creating GitHub repo via gh… ($REPO_NAME, $VISIBILITY)"
  gh repo create "$REPO_NAME" --"$VISIBILITY" --source=. --remote=origin --push -y
else
  echo "ℹ️ gh (GitHub CLI) not found."
  echo "To create a remote manually:"
  echo "  1) Create an empty repo named $REPO_NAME on GitHub"
  echo "  2) Run:"
  echo "     git remote add origin https://github.com/<user>/$REPO_NAME.git"
  echo "     git push -u origin $DEFAULT_BRANCH"
fi

echo "✅ Git initialized. Branch: $DEFAULT_BRANCH"
