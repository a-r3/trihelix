#!/usr/bin/env bash
set -euo pipefail
python3 scripts/ep-to-tasks.py
echo "✅ EP import done → docs/TASKS.md (EP_IMPORT bloku yeniləndi)"
