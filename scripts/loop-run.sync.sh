#!/usr/bin/env bash
set -euo pipefail

# Safe Mode
source scripts/safe-mode.sh
safe_mode_banner

BUS_FILE=".helix/bus/events.ndjson"
emit() {
  mkdir -p "$(dirname "$BUS_FILE")"
  ts=$(date -Iseconds)
  printf '{"ts":"%s","type":"%s","payload":%s}\n' "$ts" "$1" "${2:-{}}" >> "$BUS_FILE"
  echo "➕ emitted: $1"
}

echo "🔁 TriHelix Sync Loop — via Context Bus"
emit "loop.start" '{"phase":"Genesis"}' || true

# Atlas
bash modules/atlas/bin/atlas-plan.sh
emit "atlas.plan" "$(jq -c '. // {}' modules/atlas/plans/plan.json 2>/dev/null || echo '{}')"

echo "Synchronizing code scaffold…"
# Genom
bash modules/genom/bin/genom-generate.sh
emit "genom.generate" '{"ok":true}'

# Diagno
bash modules/diagno/bin/diagno-scan.sh
emit "diagno.scan" "$(cat modules/diagno/out/insights.json)"

# Health → Insights → Decision → Guided fixes
bash scripts/health-score.sh
python3 scripts/insight-engine.py
bash scripts/decision-model.sh
bash scripts/guided-fix.sh

# EP → Tasks (phase-aware) + tamamlanmışların arxivləndirməsi
bash scripts/ep-import.sh
bash scripts/task-sync.sh

# Atlas ep_tasks enrich + Diagno phase coverage
bash scripts/atlas-ep-embed.sh || true
bash scripts/diagno-phase-coverage.sh || true

# Telemetry/state və metrics
bash scripts/metrics.sh
bash scripts/loop-run.sh

emit "loop.finish" '{"status":"ok"}'
echo "✅ Sync loop complete"
