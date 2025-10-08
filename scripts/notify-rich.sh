#!/usr/bin/env bash
set -euo pipefail
URL="${NOTIFY_WEBHOOK:-}"
EVENT="${1:-event}"
TEXT="${2:-"TriHelix update"}"
[ -n "$URL" ] || { echo "⚠️ NOTIFY_WEBHOOK not set; skipping."; exit 0; }
payload=$(cat <<JSON
{
  "username": "helix-bot",
  "content": "**${EVENT}** — ${TEXT}",
  "embeds": [{
    "title": "TriHelix",
    "description": "${TEXT}",
    "timestamp": "$(date -Iseconds)"
  }]
}
JSON
)
curl -sf -H "Content-Type: application/json" -d "${payload}" "$URL" >/dev/null && echo "✅ Notified"
