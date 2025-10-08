#!/usr/bin/env bash
set -e
echo "🔄 Refreshing CONTEXT.yaml from snapshot metadata (Python-based)"
snap=".helix/memory/trihelix.snapshot.json"
test -f "$snap" || { echo "No snapshot found"; exit 1; }
last=$(python3 - <<'PY'
import json,sys
print(json.load(open(".helix/memory/trihelix.snapshot.json")).
      get("last_update",""))
PY
)
# Əvəzləmə: last_updated sətrini saxlayırıq, dəyəri yeniləyirik
tmp=$(mktemp)
python3 - "$last" <<'PY' > "$tmp"
import sys,re
last=sys.argv[1]
with open("CONTEXT.yaml","r",encoding="utf-8") as f:
    s=f.read()
if re.search(r'^last_updated:\s*.*$', s, flags=re.M):
    s=re.sub(r'^(last_updated:\s*).*$',
             r'\g<1>'+last, s, flags=re.M)
else:
    s += f"\nlast_updated: {last}\n"
print(s)
PY
mv "$tmp" CONTEXT.yaml
echo "✅ CONTEXT.yaml refreshed (last_updated=${last:-N/A})"
