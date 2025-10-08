#!/usr/bin/env bash
set -euo pipefail
CMD="${1:-}"
PIDF=".helix/agent.pid"
LOGF=".helix/logs/agent-$(date +%Y%m%d).log"
INTERVAL="${INTERVAL:-120}"  # seconds between loops

start_agent() {
  if [ -f "$PIDF" ] && kill -0 "$(cat "$PIDF")" 2>/dev/null; then
    echo "ℹ️  Agent already running (pid=$(cat "$PIDF"))."; return 0
  fi
  mkdir -p .helix/logs
  nohup bash -c '
    trap "echo Stopping agent; exit 0" INT TERM
    while true; do
      echo "$(date -Iseconds) :: agent tick" | tee -a "'"$LOGF"'"
      if bash scripts/loop-run.sync.sh >> "'"$LOGF"'" 2>&1; then
        echo "$(date -Iseconds) :: loop ok" | tee -a "'"$LOGF"'"
      else
        echo "$(date -Iseconds) :: loop failed" | tee -a "'"$LOGF"'"
      fi
      sleep "'"$INTERVAL"'"
    done
  ' >/dev/null 2>&1 &
  echo $! > "$PIDF"
  echo "✅ Agent started (pid=$(cat "$PIDF"), interval=${INTERVAL}s). Logs → $LOGF"
}

stop_agent() {
  if [ -f "$PIDF" ]; then
    kill "$(cat "$PIDF")" 2>/dev/null || true
    rm -f "$PIDF"
    echo "🛑 Agent stopped."
  else
    echo "ℹ️  No agent pidfile found."
  fi
}

status_agent() {
  if [ -f "$PIDF" ] && kill -0 "$(cat "$PIDF")" 2>/dev/null; then
    echo "✅ Agent running (pid=$(cat "$PIDF"))"
  else
    echo "❌ Agent not running"
  fi
}

case "$CMD" in
  start) start_agent;;
  stop) stop_agent;;
  status) status_agent;;
  *) echo "Usage: $0 {start|stop|status}  (env: INTERVAL=<secs>)"; exit 2;;
esac
