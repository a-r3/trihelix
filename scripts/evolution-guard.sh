#!/usr/bin/env bash
set -euo pipefail
fail=0

check_file() {
  local p="$1"; local tag="$2"
  if [ ! -s "$p" ]; then
    echo "❌ Missing/empty: $p  ($tag)"; fail=1
  else
    echo "✅ OK: $p"
  fi
}

echo "🧭 Evolution Guard — checking canonical artefacts…"
check_file "helix/EVALUATION_PLAN_FULL.md" "Helix evolution (0→100)"
check_file "modules/atlas/EVALUATION_PLAN.md" "Atlas evolution"
check_file "modules/genom/EVALUATION_PLAN.md" "Genom evolution"
check_file "modules/diagno/EVALUATION_PLAN.md" "Diagno evolution"
check_file "docs/ROADMAP.md" "Roadmap"
check_file "docs/TASKS.md" "Tasks (current sprint)"

if [ $fail -eq 0 ]; then
  echo "🎯 Evolution baseline intact."
else
  echo "⚠️ Evolution baseline has gaps. Fill the missing artefacts."
  exit 2
fi
