#!/usr/bin/env bash
set -e
echo "🔁 TriHelix Loop — Plan→Build→Analyze"
start_ts=$(date -Iseconds)
state_file=".helix/state.json"
logs_dir=".helix/logs"; mkdir -p "$logs_dir"
log="$logs_dir/loop-$(date +%Y%m%d-%H%M%S).json"

# Simulated steps (replace with real calls)
echo "• Atlas: planning…"
sleep 0.2
echo "• Genom: generating…"
sleep 0.2
echo "• Diagno: analyzing…"
sleep 0.2

finish_ts=$(date -Iseconds)
# Update state
python3 - "$state_file" "$log" "$start_ts" "$finish_ts" <<'PY'
import json, sys
state_path, log_path, s, f = sys.argv[1:5]
with open(state_path) as r: st=json.load(r)
st["iteration"]=int(st.get("iteration",0))+1
st["last_loop"]={"status":"ok","started_at":s,"finished_at":f,"artifacts":{"log":log_path}}
with open(state_path,"w") as w: json.dump(st,w,indent=2)
with open(log_path,"w") as w: json.dump(st["last_loop"],w,indent=2)
print("State updated:", state_path)
print("Log written:", log_path)
PY

# Memory summary
echo -e "\n## Iteration: Genesis/0-20 @ $(date -Iseconds)\n- Atlas: plan stub\n- Genom: generate stub\n- Diagno: analyze stub\n- Helix: state/log updated\n- Next: replace stubs with real calls\n" >> MEMORY.md

# Snapshot
python3 - <<'PY'
import json, datetime
snap = {
  "project":"TriHelix",
  "phase":"Genesis",
  "range":"0-20",
  "last_update": datetime.date.today().isoformat(),
  "notes":["Loop executed (stub)"]
}
open(".helix/memory/trihelix.snapshot.json","w").write(json.dumps(snap,indent=2))
print("📸 Snapshot updated")
PY
echo "✅ Loop complete"
