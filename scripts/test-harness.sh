#!/usr/bin/env bash
set -euo pipefail
echo "🧪 TriHelix test harness"
chmod +x scripts/*.sh modules/*/bin/*.sh || true
# 1) full sync loop
bash scripts/loop-run.sync.sh
# 2) gates
bash scripts/health-gate.sh
bash scripts/policy-guard.sh
bash scripts/lint-gate.sh
bash scripts/coverage-gate.sh
echo "✅ all gates passed"
