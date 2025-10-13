#!/usr/bin/env bash
set -euo pipefail
source scripts/safe-mode.sh

PLAN="modules/atlas/plans/plan.json"
mkdir -p "$(dirname "$PLAN")"

ts=$(date -Iseconds)
sprint="S-$(date +%Y%m%d)"
cat > "$PLAN" <<JSON
{
  "ts": "$ts",
  "sprint": "$sprint",
  "goals": ["sync bus prototype", "scheduler online", "metrics collector"]
}
JSON

echo "✅ Atlas: wrote plan → $PLAN"
[ "${SAFE_MODE}" = "1" ] && echo "🛡️  (Safe Mode: meta-only write allowed)"
