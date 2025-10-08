#!/usr/bin/env bash
set -euo pipefail
BUS=".helix/bus"; mkdir -p "$BUS"
STREAM="$BUS/events.ndjson"
CMD="${1:-}"; shift || true

emit() {
  local type="$1"; shift
  local payload="${1:-{}}"
  local ts=$(date -Iseconds)
  printf '{"ts":"%s","type":"%s","payload":%s}\n' "$ts" "$type" "$payload" >> "$STREAM"
  echo "➕ emitted: $type"
}

tailf() {
  touch "$STREAM"
  echo "👂 listening on $STREAM (Ctrl+C to exit)"
  tail -f "$STREAM"
}

case "$CMD" in
  emit) emit "${1:?type required}" "${2:-{}}";;
  listen) tailf;;
  *) echo "Usage: $0 {emit <type> [json]|listen}"; exit 2;;
esac
