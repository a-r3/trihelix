#!/usr/bin/env python3
import re, os, datetime, pathlib

# Sources
META_ROADMAP = "docs/ROADMAP.md"
PROJECT_ROADMAP_DEFAULT = "docs/PROJECT_ROADMAP.md"
EP_SOURCES = [
  ("Helix",  "helix/EVALUATION_PLAN_FULL.md"),
  ("Atlas",  "modules/atlas/EVALUATION_PLAN.md"),
  ("Genom",  "modules/genom/EVALUATION_PLAN.md"),
  ("Diagno", "modules/diagno/EVALUATION_PLAN.md"),
]

TASKS_FILE = "docs/TASKS.md"
META_BEGIN = "<!-- BEGIN:EP_IMPORT_META -->"
META_END   = "<!-- END:EP_IMPORT_META -->"
PRJ_BEGIN  = "<!-- BEGIN:EP_IMPORT_PROJECT -->"
PRJ_END    = "<!-- END:EP_IMPORT_PROJECT -->"

# bullets, e.g. "- [ ] text @track:meta @phase:20-40"
BULLET_RX = re.compile(r"""^\s*(?:-\s*\[\s*\]\s+|-\s*\[x\]\s+|[-*+•–—]\s+)(.+?)\s*$""", re.U)
TAG_RX = re.compile(r"""@(?P<k>track|phase)\s*:\s*(?P<v>[A-Za-z0-9\-]+)""")

H2_RX = re.compile(r"""^##\s*(?P<range>\d+\s*[–—-]\s*\d+)\s+(?P<name>.+?)\s*$""", re.U)
DASHES = dict.fromkeys(map(ord,"–—−"),"-")

def norm(s:str)->str: return s.translate(DASHES)
def a_clean(r:str)->str: return norm(r).replace(" ","")

def read(p):
    try: return pathlib.Path(p).read_text(encoding="utf-8")
    except: return ""

def get_current_phase():
    ph="Genesis"; rg="0-20"
    s=read("CONTEXT.yaml")
    m=re.search(r"^current_phase:\s*$", s, flags=re.M)
    if m:
        a=re.search(r"^\s*name:\s*(.+)$", s[m.end():], flags=re.M)
        b=re.search(r"^\s*range:\s*(.+)$", s[m.end():], flags=re.M)
        if a: ph=a.group(1).strip()
        if b: rg=b.group(1).strip()
    return ph, a_clean(rg)

def parse_line(line):
    """Returns (text, track, phase) or None if not a bullet."""
    m = BULLET_RX.match(line)
    if not m: return None
    raw = m.group(1).strip()
    # pull tags
    tags = dict((mm.group('k'), mm.group('v')) for mm in TAG_RX.finditer(raw))
    # strip tags from text
    text = TAG_RX.sub("", raw).strip()
    # defaults
    track = tags.get("track","meta").lower()
    phase = a_clean(tags.get("phase",""))  # may be blank, then caller fills
    return text, track, phase

def bullets_with_tags(md):
    out=[]
    for ln in md.splitlines():
        pr = parse_line(ln)
        if not pr: continue
        # skip completed ones (we only import open tasks)
        if ln.strip().startswith("- [x]"):
            continue
        out.append(pr)
    return out

def split_sections(md):
    md=norm(md)
    secs={}; cur=None; buf=[]
    for ln in md.splitlines():
        h=H2_RX.match(ln)
        if h:
            if cur and buf: secs[cur]="\n".join(buf)
            cur=(a_clean(h.group("range")), h.group("name").strip())
            buf=[]
            continue
        if cur: buf.append(ln)
    if cur and buf: secs[cur]="\n".join(buf)
    return secs

def pick_phase_items_from_markdown(md, cur_phase, cur_range):
    """Extract plain bullets from a specific H2 phase section (roadmap style)."""
    secs = split_sections(md)
    # exact range
    for (rng,_),txt in secs.items():
        if a_clean(rng)==a_clean(cur_range):
            return [t for t,_,_ in bullets_with_tags(txt) or []] or bullets_plain(txt)
    # fuzzy by name
    for (rng,name),txt in secs.items():
        if cur_phase.lower() in name.lower():
            return [t for t,_,_ in bullets_with_tags(txt) or []] or bullets_plain(txt)
    return []

def bullets_plain(md):
    """Plain bullets without tags (roadmap lines)"""
    out=[]
    for ln in md.splitlines():
        m=BULLET_RX.match(ln)
        if not m: continue
        if ln.strip().startswith("- [x]"): continue
        out.append(m.group(1).strip())
    return out

def render_block(begin, end, items, title, meta):
    ts=datetime.datetime.now().isoformat()
    spr="S-"+datetime.datetime.now().strftime("%Y%m%d")
    lines=[begin, f"### {title} @ {ts} ({spr})"]
    if not items:
        lines.append("_No tasks parsed for current phase._")
    else:
        for origin, txt in items:
            lines.append(f"- [ ] ({origin}) {txt}")
    lines.append("")
    lines.append("<details><summary>parser meta</summary>")
    for k,v in meta.items(): lines.append(f"- {k}: {v}")
    lines.append("</details>")
    lines.append(end)
    return "\n".join(lines)+"\n"

def write_or_replace_block(s, begin, end, block):
    import re
    if begin in s and end in s:
        return re.sub(re.escape(begin)+r".*?"+re.escape(end), block, s, flags=re.S)
    return s.rstrip()+"\n\n"+block

def main():
    cur_phase, cur_range = get_current_phase()

    # -------- META track aggregation --------
    meta_meta={}
    meta_items=[]

    # EP sources (tag-aware)
    ep_meta_count=0
    ep_prj_count=0
    for mod, path in EP_SOURCES:
        md = read(path)
        cnt=0
        if md:
            for txt,track,phase in bullets_with_tags(md):
                # default phase to current if blank
                ph = phase or cur_range
                if a_clean(ph) != a_clean(cur_range):
                    continue
                if track == "meta":
                    meta_items.append((mod, txt)); ep_meta_count+=1; cnt+=1
                elif track == "project":
                    # collected later into PROJECT track
                    ep_prj_count+=1  # meta says how many potential project items exist
        meta_meta[f"EP[{mod}]_meta_for_phase"]=cnt

    # Roadmap (meta) — plain bullets
    mrd = read(META_ROADMAP)
    if mrd:
        for t in pick_phase_items_from_markdown(mrd, cur_phase, cur_range):
            meta_items.append(("Roadmap", t))
    # dedupe
    seen=set(); meta_uniq=[]
    for origin, txt in meta_items:
        k=(origin, txt.strip())
        if k in seen: continue
        seen.add(k); meta_uniq.append((origin, txt.strip()))
    meta_meta["meta_total"]=len(meta_uniq)
    meta_meta["ep_meta_candidates"]=ep_meta_count

    # -------- PROJECT track aggregation --------
    prj_meta={}
    prj_items=[]

    # EP sources (tag-aware project)
    for mod, path in EP_SOURCES:
        md = read(path)
        cnt=0
        if md:
            for txt,track,phase in bullets_with_tags(md):
                ph = phase or cur_range
                if a_clean(ph) != a_clean(cur_range):
                    continue
                if track == "project":
                    prj_items.append(("EP:"+mod, txt)); cnt+=1
        prj_meta[f"EP[{mod}]_project_for_phase"]=cnt

    # Project roadmap (optional)
    prj_src = PROJECT_ROADMAP_DEFAULT
    sctx=read("CONTEXT.yaml")
    ms = re.search(r"project_track:.*?\n\s*source:\s*(.+)$", sctx, flags=re.M|re.S)
    if ms:
        src_line = ms.group(1).strip()
        if src_line: prj_src = src_line
    prj_meta["PROJECT.source"]=prj_src

    pm = read(prj_src)
    if pm:
        for t in pick_phase_items_from_markdown(pm, cur_phase, cur_range):
            prj_items.append(("Project", t))

    # dedupe
    seen=set(); prj_uniq=[]
    for origin, txt in prj_items:
        k=(origin, txt.strip())
        if k in seen: continue
        seen.add(k); prj_uniq.append((origin, txt.strip()))
    prj_meta["project_total"]=len(prj_uniq)
    prj_meta["ep_project_candidates"]=ep_prj_count

    # -------- Write TASKS.md --------
    os.makedirs("docs", exist_ok=True)
    p=pathlib.Path(TASKS_FILE)
    if not p.exists(): p.write_text("# Tasks\n\n", encoding="utf-8")
    s=p.read_text(encoding="utf-8")

    meta_block = render_block(META_BEGIN, META_END, meta_uniq,
                              f"META EP Import — {cur_phase} ({cur_range})", meta_meta)
    prj_block  = render_block(PRJ_BEGIN, PRJ_END, prj_uniq,
                              f"PROJECT Import — {cur_phase} ({cur_range})", prj_meta)

    s = write_or_replace_block(s, META_BEGIN, META_END, meta_block)
    s = write_or_replace_block(s, PRJ_BEGIN,  PRJ_END,  prj_block)
    p.write_text(s, encoding="utf-8")

    print(f"✅ META items: {len(meta_uniq)}  • PROJECT items: {len(prj_uniq)}  → {TASKS_FILE}")
    print(f"   META[ep_meta_candidates]: {ep_meta_count}  PROJECT[ep_project_candidates]: {ep_prj_count}")
    print(f"   META[ROADMAP]: {len(pick_phase_items_from_markdown(read(META_ROADMAP), cur_phase, cur_range))}  PROJECT[src={prj_src}]")
