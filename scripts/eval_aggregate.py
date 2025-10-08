#!/usr/bin/env python3
import os, json, re, hashlib, datetime, sys
root = os.getcwd()

# EVALUATION_PLAN.md fayllarını topla
plan_files = []
for basedir, _, files in os.walk(root):
    for f in files:
        if f == "EVALUATION_PLAN.md":
            plan_files.append(os.path.join(basedir, f))

def parse_plan(path):
    txt = open(path, "r", encoding="utf-8").read()
    rel = os.path.relpath(path, root)

    # başlıqları parçala
    sections = {}
    current = None
    for line in txt.splitlines():
        m = re.match(r'^\s{0,3}#{1,6}\s+(.*)$', line)
        if m:
            current = m.group(1).strip().lower()
            sections[current] = []
        elif current is not None:
            sections[current].append(line)

    # checkbox-lar
    checks = re.findall(r'-\s*\[( |x|X)\]\s*(.+)', txt)
    done = [c[1].strip() for c in checks if c[0].lower() == 'x']
    todo = [c[1].strip() for c in checks if c[0].strip() == '' or c[0] == ' ']

    def grab(key):
        for k in sections:
            if key in k:
                return "\n".join(sections[k]).strip()
        return ""

    ident = os.path.basename(os.path.dirname(path))
    h = hashlib.sha1(txt.encode()).hexdigest()[:10]
    return {
        "module": ident,
        "path": rel,
        "hash": h,
        "objectives": grab("objective"),
        "metrics": grab("metric"),
        "acceptance": grab("acceptance"),
        "rollback": grab("rollback"),
        "done": done,
        "todo": todo,
    }

reports = [parse_plan(p) for p in sorted(plan_files)]
summary = {
    "generated_at": datetime.datetime.utcnow().isoformat()+"Z",
    "plans_count": len(reports),
    "reports": reports
}

os.makedirs("docs", exist_ok=True)
json_path = "docs/EVAL_SUMMARY.json"
md_path   = "docs/EVAL_SUMMARY.md"

with open(json_path, "w", encoding="utf-8") as f:
    json.dump(summary, f, ensure_ascii=False, indent=2)

lines = []
lines.append("# Evaluation Summary\n")
lines.append(f"- Generated: {summary['generated_at']}")
lines.append(f"- Plans: {summary['plans_count']}\n")

for r in reports:
    lines.append(f"## {r['module']} ({r['path']})  \n`{r['hash']}`\n")
    if r["objectives"]:
        lines.append("**Objectives**\n")
        lines.append(r["objectives"] + "\n")
    if r["metrics"]:
        lines.append("**Metrics**\n")
        lines.append(r["metrics"] + "\n")
    if r["acceptance"]:
        lines.append("**Acceptance Criteria**\n")
        lines.append(r["acceptance"] + "\n")
    if r["rollback"]:
        lines.append("**Rollback**\n")
        lines.append(r["rollback"] + "\n")
    if r["done"] or r["todo"]:
        lines.append("**Checklist**")
        if r["done"]:
            lines.extend([f"- [x] {item}" for item in r["done"]])
        if r["todo"]:
            lines.extend([f"- [ ] {item}" for item in r["todo"]])
        lines.append("")
    lines.append("---\n")

with open(md_path, "w", encoding="utf-8") as f:
    f.write("\n".join(lines))

sys.exit(0)
