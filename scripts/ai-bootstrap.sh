#!/usr/bin/env bash
set -e
echo "🚀 AI Bootstrap — loading context and initializing state"
test -f CONTEXT.yaml || { echo "Missing CONTEXT.yaml"; exit 1; }
test -f .helix/state.json || echo '{"phase":"Genesis","iteration":0,"last_loop":{"status":"not-run","artifacts":{}}}' > .helix/state.json
echo "✅ Ready. Next: run scripts/loop-run.sh"
