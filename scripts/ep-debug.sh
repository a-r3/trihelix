#!/usr/bin/env bash
set -euo pipefail
echo "🔍 EP Debug — sources & roadmap breakdown"
python3 - <<'PY'
import re, pathlib, json, sys
from pprint import pprint

def r(p): 
    try: return pathlib.Path(p).read_text(encoding='utf-8')
    except: return ''

files = {
  "Helix": "helix/EVALUATION_PLAN_FULL.md",
  "Atlas": "modules/atlas/EVALUATION_PLAN.md",
  "Genom": "modules/genom/EVALUATION_PLAN.md",
  "Diagno":"modules/diagno/EVALUATION_PLAN.md",
  "Roadmap": "docs/ROADMAP.md"
}
for k,p in files.items():
    s=r(p)
    print(f"- {k}: {'OK' if s else 'MISSING/EMPTY'} ({p})")
PY
echo
python3 scripts/ep-to-tasks.py >/tmp/ep.run 2>&1 || true
cat /tmp/ep.run
sed -n '/BEGIN:EP_IMPORT/,/END:EP_IMPORT/p' docs/TASKS.md || true
