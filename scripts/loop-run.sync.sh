#!/usr/bin/env bash
set -euo pipefail
echo "🔁 TriHelix Sync Loop — via Context Bus"
BUS_EMIT="scripts/context-bus.sh emit"

$BUS_EMIT "loop.start" '{"phase":"CognitiveCore"}' || true

# Atlas → plan
bash modules/atlas/bin/atlas-plan.sh
$BUS_EMIT "atlas.plan" "$(cat modules/atlas/plans/plan.json)"

# Genom → generate
bash modules/genom/bin/genom-generate.sh
$BUS_EMIT "genom.generate" '{"ok":true}'

# Diagno → scan
bash modules/diagno/bin/diagno-scan.sh
$BUS_EMIT "diagno.scan" "$(cat modules/diagno/out/insights.json)"

# Health → Insights → Decision → Guided fixes
bash scripts/health-score.sh
python3 scripts/insight-engine.py
bash scripts/decision-model.sh
bash scripts/guided-fix.sh

# Telemetry/state
bash scripts/loop-run.sh

# Metrics (telemetriya sonra)
bash scripts/metrics.sh

# Health Gate (en sonda; CI üçün sərt qapı)
bash scripts/health-gate.sh

$BUS_EMIT "loop.finish" '{"status":"ok"}' || true
echo "✅ Sync loop complete"
