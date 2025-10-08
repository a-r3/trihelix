#!/usr/bin/env bash
set -euo pipefail
URL="${NOTIFY_WEBHOOK:-}"
EVENT="${1:-generic}"
PAYLOAD="${2:-{}}"
[ -n "$URL" ] || { echo "⚠️ NOTIFY_WEBHOOK not set; skipping."; exit 0; }
curl -sS -X POST -H "Content-Type: application/json" \
  -d "{\"event\":\"$EVENT\",\"payload\":$PAYLOAD}" "$URL" >/dev/null && \
  echo "🔔 Notified: $EVENT"
