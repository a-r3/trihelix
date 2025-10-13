#!/usr/bin/env bash
set -euo pipefail
mkdir -p .helix/memory
python3 - <<'PY'
import json, datetime, os
snap = {
  "project": "TriHelix",
  "phase": "Conductor",
  "range": "40-60",
  "last_update": datetime.date.today().isoformat(),
  "notes": ["Loop executed"]
}
os.makedirs(".helix/memory", exist_ok=True)
with open(".helix/memory/trihelix.snapshot.json","w") as f:
    json.dump(snap, f, indent=2)
print("📸 Snapshot updated → .helix/memory/trihelix.snapshot.json")
PY
