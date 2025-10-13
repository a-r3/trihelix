#!/usr/bin/env bash
# TriHelix — Telemetry Loop (stub, stable)
set -euo pipefail

STATE_FILE=".helix/state.json"
LOGS_DIR=".helix/logs"
MEM_FILE="MEMORY.md"
SNAP_SCRIPT="scripts/snapshot-write.sh"

mkdir -p ".helix/memory" "$LOGS_DIR"

# Phase/Range from CONTEXT.yaml (fallbacks)
PHASE="$(awk '/^current_phase:/{f=1;next} f && /name:/{print $2; exit}' CONTEXT.yaml 2>/dev/null || true)"
PHASE="${PHASE:-Genesis}"
RANGE="$(awk '/^current_phase:/{f=1;next} f && /range:/{print $2; exit}' CONTEXT.yaml 2>/dev/null || true)"
RANGE="${RANGE:-0-20}"

echo "🔁 TriHelix Loop — Plan→Build→Analyze"
echo "• Atlas: planning…"
echo "• Genom: generating…"
echo "• Diagno: analyzing…"

START_TS="$(date -Iseconds)"
LOG_FILE="$LOGS_DIR/loop-$(date +%Y%m%d-%H%M%S).json"

# 1) Previous iteration
ITER_PREV=$(python3 - <<'PY'
import json, os, sys
p=".helix/state.json"
it=0
if os.path.exists(p):
  try: it=int(json.load(open(p)).get("iteration",0))
  except Exception: it=0
print(it)
PY
)

# 2) Write loop log
python3 - <<PY
import json, datetime, sys
log_path = "${LOG_FILE}"
payload = {
  "status":"ok",
  "started_at":"${START_TS}",
  "finished_at": datetime.datetime.now().isoformat(),
  "artifacts": {}
}
with open(log_path,"w") as f: json.dump(payload,f,indent=2)
print("Log written:", log_path)
PY

# 3) Update state.json
python3 - <<PY
import json, os
state_path = "${STATE_FILE}"
iter_prev = int("${ITER_PREV}")
log = json.load(open("${LOG_FILE}"))
state = {
  "phase": "${PHASE}",
  "iteration": iter_prev + 1,
  "last_loop": {
    "status": log.get("status","ok"),
    "started_at": log.get("started_at"),
    "finished_at": log.get("finished_at"),
    "artifacts": log.get("artifacts",{})
  }
}
os.makedirs(os.path.dirname(state_path), exist_ok=True)
json.dump(state, open(state_path,"w"), indent=2)
print("State updated:", state_path)
PY

# 4) Human-readable memory
{
  echo
  echo "## Iteration: ${PHASE}/${RANGE} @ $(date -Iseconds)"
  echo "- Atlas: plan stub"
  echo "- Genom: generate stub"
  echo "- Diagno: analyze stub"
  echo "- Helix: state/log updated"
  echo "- Next: replace stubs with real calls"
  echo
} >> "$MEM_FILE"

# 5) Snapshot (idempotent)
if [ -x "$SNAP_SCRIPT" ]; then
  bash "$SNAP_SCRIPT"
else
  python3 - <<'PY'
import json, datetime, os
os.makedirs(".helix/memory", exist_ok=True)
snap = {
  "project":"TriHelix",
  "phase":"unknown",
  "range":"unknown",
  "last_update": datetime.date.today().isoformat(),
  "notes":["Loop executed (fallback snapshot)"]
}
json.dump(snap, open(".helix/memory/trihelix.snapshot.json","w"), indent=2)
print("📸 Snapshot updated (fallback)")
PY
fi

echo "✅ Loop complete"

