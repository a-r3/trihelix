#!/usr/bin/env bash
set -euo pipefail
PLAN="modules/atlas/plans/plan.json"
OUT_DIR="modules/genom/out"; mkdir -p "$OUT_DIR" "code"
ts=$(date -Iseconds)
cat > "$OUT_DIR/diff.json" <<JSON
{"ts":"$ts","changes":[{"path":"code/HELLO.txt","op":"create"}]}
JSON
echo "Synchronizing code scaffold…"
echo "Hello from Genom @ $ts" > code/HELLO.txt
echo "🧬 Genom: generated artifacts → $OUT_DIR, code/HELLO.txt"
