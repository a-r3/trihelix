#!/usr/bin/env bash
set -euo pipefail
source scripts/safe-mode.sh

TASKS="docs/TASKS.md"
PR_MD="modules/genom/out/pr_draft.md"

# Ensure meta areas exist
mkdir -p "docs" "modules/genom/out"

# Write hints into PR draft (meta)
ts=$(date -Iseconds)
{
  echo
  echo "> Guided fixes appended @ $ts"
} >> "$PR_MD"

# Update Tasks (meta)
if grep -q "<!-- BEGIN:EP_IMPORT -->" "$TASKS" 2>/dev/null; then
  echo "🔧 guided-fix: EP import present; leaving as-is"
else
  echo "🔧 guided-fix: adding EP_IMPORT block placeholder"
  cat >> "$TASKS" <<'MD'

<!-- BEGIN:EP_IMPORT -->
### EP Import (placeholder)
- [ ] (Roadmap) Full loop engine
- [ ] (Roadmap) Health scoring
- [ ] (Roadmap) Adaptive roadmap update
<!-- END:EP_IMPORT -->
MD
fi

# Example of a potential code write: BLOCK in Safe Mode
TARGET="code/EXAMPLE_CHANGE.txt"
if ! safe_write_check "$TARGET"; then
  echo "ℹ️  guided-fix: code write prevented ($TARGET)"
else
  mkdir -p "code"
  echo "Example change @ $ts" > "$TARGET"
  echo "✅ guided-fix: wrote $TARGET"
fi

echo "✅ guided-fix complete"
