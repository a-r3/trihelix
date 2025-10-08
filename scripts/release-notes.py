#!/usr/bin/env python3
import json, datetime, os, glob

def read_json(path, default=None):
    try:
        with open(path) as f: return json.load(f)
    except Exception:
        return default

health = read_json(".helix/health.json", {})
metrics = read_json(".helix/metrics.json", {})
insights = read_json(".helix/insights.json", {})
decision = read_json(".helix/decision.json", {})

ts = datetime.datetime.now().isoformat()
notes = []
notes.append(f"# TriHelix Release Notes — {ts}")
notes.append("")
notes.append("## Summary")
notes.append(f"- Health Score: **{health.get('score','N/A')}**")
notes.append(f"- Loops OK/Total: **{metrics.get('ok_count','?')} / {metrics.get('total_loops','?')}**")
if insights:
    notes.append(f"- Risk Level: **{insights.get('risk','unknown')}**")
notes.append("")

if decision.get("decision"):
    notes.append("## Decision")
    notes.append(f"- Action: **{decision['decision'].get('action','')}**")
    goals = decision['decision'].get('goals',[])
    if goals:
        notes.append("- Goals:")
        for g in goals: notes.append(f"  - {g}")
    notes.append("")

# Changes/changelog (best-effort)
logs = sorted(glob.glob(".helix/logs/loop-*.json"))
if logs:
    notes.append("## Telemetry")
    notes.append(f"- Recent loops: {len(logs)}")
    notes.append("")

# Append last roadmap update tail if exists
try:
    with open("docs/ROADMAP.md","r",encoding="utf-8") as f:
        tail = f.read().splitlines()[-20:]
        notes.append("## Roadmap Tail")
        notes.append("```")
        notes.extend(tail)
        notes.append("```")
        notes.append("")
except Exception:
    pass

out = "\n".join(notes)
os.makedirs("docs", exist_ok=True)
with open("docs/RELEASE_NOTES.md","w",encoding="utf-8") as f:
    f.write(out)
print("✅ Release notes → docs/RELEASE_NOTES.md")
