#!/usr/bin/env bash
set -e
echo "🔗 Syncing state & memory"
mkdir -p .helix/logs
test -f .helix/state.json || echo '{}' > .helix/state.json
test -f .helix/memory/trihelix.snapshot.json || echo '{}' > .helix/memory/trihelix.snapshot.json
echo "✅ Done"
