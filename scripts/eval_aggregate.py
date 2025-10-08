#!/usr/bin/env python3
import os, json, hashlib, datetime, sys
root = os.getcwd()
plans = []
for basedir, _, files in os.walk(root):
    for f in files:
        if f == "EVALUATION_PLAN.md":
            p = os.path.join(basedir,f)
            plans.append(os.path.relpath(p, root))
summary = {
  "generated_at": datetime.datetime.utcnow().isoformat()+"Z",
  "count": len(plans),
  "plans": plans
}
os.makedirs("docs", exist_ok=True)
with open("docs/EVAL_SUMMARY.json","w",encoding="utf-8") as w:
    json.dump(summary,w,indent=2,ensure_ascii=False)
with open("docs/EVAL_SUMMARY.md","w",encoding="utf-8") as w:
    w.write("# Evaluation Summary\n\n")
    w.write(f"- Generated: {summary['generated_at']}\n")
    w.write(f"- Plans: {summary['count']}\n\n")
    for p in plans:
        w.write(f"- {p}\n")
print(f"Wrote docs/EVAL_SUMMARY.md and .json ({summary['count']} plans).")
