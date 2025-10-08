#!/usr/bin/env python3
import json, glob, os, datetime
logs = sorted(glob.glob(".helix/logs/loop-*.json"))
ins = {}
try:
    ins = json.load(open("modules/diagno/out/insights.json"))
except: pass

ok = 0
last = None
for p in logs:
    try:
        d=json.load(open(p))
        if d.get("status")=="ok": ok+=1
        last=d.get("finished_at", last)
    except: pass

score = 0
try:
    h=json.load(open(".helix/health.json")); score=h.get("score",0)
except: pass

out = {
  "ts": datetime.datetime.now().isoformat(),
  "loops_total": len(logs),
  "loops_ok": ok,
  "last_finished_at": last,
  "health_score": score,
  "diagno_quick_wins": ins.get("quick_wins", []),
  "diagno_strategic": ins.get("strategic", []),
  "risk": ins.get("risk", "unknown")
}
os.makedirs(".helix", exist_ok=True)
json.dump(out, open(".helix/insights.json","w"), indent=2)
print("✅ insights → .helix/insights.json")
