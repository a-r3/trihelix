#!/usr/bin/env bash
set -euo pipefail
SNAP_DIR=".helix/memory/snapshots"; mkdir -p "$SNAP_DIR"
BASE=".helix/memory/trihelix.snapshot.json"
TS=$(date +%Y%m%d-%H%M%S)
TGT="$SNAP_DIR/snap-$TS.json"

# Create rotated copy
if [ -f "$BASE" ]; then
  cp "$BASE" "$TGT"
  echo "📸 snapshot rotated → $TGT"
else
  echo '{"project":"TriHelix"}' > "$TGT"
  echo "📸 snapshot created (empty) → $TGT"
fi

# Compact MEMORY.md heading (optional: keep last 200 lines)
if [ -f MEMORY.md ]; then
  tail -n 200 MEMORY.md > MEMORY.tmp && mv MEMORY.tmp MEMORY.md
  echo "🧹 memory compacted to last 200 lines"
fi
