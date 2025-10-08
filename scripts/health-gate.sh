#!/usr/bin/env bash
set -euo pipefail
MIN="${MIN_HEALTH:-75}"
H=".helix/health.json"
score=$(jq -r '.score // 0' "$H" 2>/dev/null || echo 0)
echo "Health Gate: score=$score, min=$MIN"
[ "$score" -lt "$MIN" ] && { echo "❌ FAIL"; exit 1; } || echo "✅ PASS"
