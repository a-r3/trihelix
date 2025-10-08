#!/usr/bin/env bash
set -euo pipefail
INTERVAL="${INTERVAL:-30}"   # seconds
MAX_RETRY="${MAX_RETRY:-3}"
LOG=".helix/logs/scheduler-$(date +%Y%m%d).log"
echo "🗓  Scheduler started (interval=${INTERVAL}s, max_retry=${MAX_RETRY})" | tee -a "$LOG"

run_loop() {
  local attempt=1
  while true; do
    if bash scripts/loop-run.sync.sh; then
      echo "$(date -Iseconds) OK loop" | tee -a "$LOG"
      break
    else
      echo "$(date -Iseconds) FAIL loop (attempt $attempt)" | tee -a "$LOG"
      if [ "$attempt" -ge "$MAX_RETRY" ]; then
        echo "$(date -Iseconds) giving up after $attempt attempts" | tee -a "$LOG"
        return 1
      fi
      sleep $(( attempt * 5 ))
      attempt=$(( attempt + 1 ))
    fi
  done
}

while true; do
  run_loop || true
  sleep "$INTERVAL"
done
