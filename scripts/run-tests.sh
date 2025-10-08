#!/usr/bin/env bash
set -euo pipefail

echo "🧪 Running TriHelix test suite (light)…"
# 0) Ensure exec
chmod +x scripts/*.sh modules/*/bin/*.sh || true

# 1) One sync loop
bash scripts/loop-run.sync.sh

# 2) Health gate
MIN_HEALTH="${MIN_HEALTH:-75}" bash scripts/health-gate.sh

# 3) Policy guard
bash scripts/policy-guard.sh

echo "✅ Tests OK"
