#!/usr/bin/env bash
set -euo pipefail
OUT="modules/atlas/plans/plan.json"; mkdir -p "$(dirname "$OUT")"
ts=$(date -Iseconds)
cat > "$OUT" <<JSON
{
  "ts": "$ts",
  "sprint": "S-$(date +%Y%m%d)",
  "goals": ["sync bus prototype", "scheduler online", "metrics collector"],
  "artifacts": ["docs/METRICS.md", ".helix/metrics.json"]
}
JSON
echo "🧭 Atlas: wrote plan → $OUT"
