#!/usr/bin/env bash
set -euo pipefail

seed() {
  local f="$1" ; local name="$2"
  cat > "$f" <<MD
# $name — Evolution Plan

## Phase 0–20 — Genesis
- [ ] @track:meta @phase:0-20 Scaffold & AI-persistence files
- [ ] @track:meta @phase:0-20 First loop prototype
- [ ] @track:project @phase:0-20 Project CI smoke

## Phase 20–40 — Synchronizer
- [ ] @track:meta @phase:20-40 Context bus (events)
- [ ] @track:meta @phase:20-40 Scheduler & retries
- [ ] @track:project @phase:20-40 Minimal feature A

## Phase 40–60 — Conductor
- [ ] @track:meta @phase:40-60 Full loop engine
- [ ] @track:meta @phase:40-60 Health scoring
- [ ] @track:project @phase:40-60 Tests for core modules
MD
  echo "✅ Seeded: $f"
}

seed "helix/EVALUATION_PLAN_FULL.md" "Helix"
seed "modules/atlas/EVALUATION_PLAN.md" "Atlas"
seed "modules/genom/EVALUATION_PLAN.md" "Genom"
seed "modules/diagno/EVALUATION_PLAN.md" "Diagno"
