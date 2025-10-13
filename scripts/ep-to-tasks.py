#!/usr/bin/env python3
import re, sys, os, datetime, pathlib

EP_SOURCES = [
  ("Helix", "helix/EVALUATION_PLAN_FULL.md"),
  ("Atlas", "modules/atlas/EVALUATION_PLAN.md"),
  ("Genom", "modules/genom/EVALUATION_PLAN.md"),
  ("Diagno","modules/diagno/EVALUATION_PLAN.md"),
]
TASKS_FILE = "docs/TASKS.md"
BEGIN = "<!-- BEGIN:EP_IMPORT -->"
END   = "<!-- END:EP_IMPORT -->"

def read(path):
    try:
        return pathlib.Path(path).read_text(encoding="utf-8")
    except:
        return ""

def extract_tasks(md, module):
    out=[]
    for line in md.splitlines():
        line=line.rstrip()
        # checklist və ya sadə bullet
        if re.match(r"^\s*-\s*\[ \]\s+.+", line):
            t=re.sub(r"^\s*-\s*\[ \]\s+","",line)
            out.append((module,t))
        elif re.match(r"^\s*-\s+.+", line):
            t=re.sub(r"^\s*-\s+","",line)
            out.append((module,t))
    return out

def render_block(tasks):
    ts = datetime.datetime.now().isoformat()
    sprint = "S-"+datetime.datetime.now().strftime("%Y%m%d")
    lines = []
    lines.append(BEGIN)
    lines.append(f"### EP Import @ {ts} ({sprint})")
    if not tasks:
        lines.append("_No tasks parsed from EP files._")
    else:
        for mod, t in tasks:
            lines.append(f"- [ ] ({mod}) {t}")
    lines.append(END)
    return "\n".join(lines)+"\n"

def write_tasks(block):
    os.makedirs("docs", exist_ok=True)
    if not os.path.exists(TASKS_FILE):
        pathlib.Path(TASKS_FILE).write_text("# Tasks\n\n",encoding="utf-8")
    s=read(TASKS_FILE)
    if BEGIN in s and END in s:
        s = re.sub(re.escape(BEGIN)+r".*?"+re.escape(END), block, s, flags=re.S)
    else:
        s = s.rstrip()+"\n\n"+block
    pathlib.Path(TASKS_FILE).write_text(s,encoding="utf-8")

def main():
    all_tasks=[]
    for mod, path in EP_SOURCES:
        md=read(path)
        if md:
            all_tasks.extend(extract_tasks(md, mod))
    # dedupe (mod,text) cütlüyü üzrə
    seen=set(); uniq=[]
    for m,t in all_tasks:
        k=(m,t.strip())
        if k in seen: continue
        seen.add(k); uniq.append((m,t.strip()))
    write_tasks(render_block(uniq))
    print(f"✅ EP→Tasks import: {len(uniq)} items → {TASKS_FILE}")

if __name__ == "__main__":
    main()
