#!/usr/bin/env python3
import re, pathlib
p=pathlib.Path("docs/ROADMAP.md")
s=p.read_text(encoding="utf-8")
# defisləri normallaşdır
s=s.replace("–","-").replace("—","-")
sec_rx=re.compile(r"(##\s*40-60[^\n]*\n)(?P<body>.*?)(?=^##\s*\d+-\d+|\Z)", re.S|re.M)
m=sec_rx.search(s)
want="- [ ] Full loop engine\n- [ ] Health scoring\n- [ ] Adaptive roadmap update\n"
if m:
    body=m.group("body")
    # əgər üç maddə yoxdursa, yenilə
    if "Full loop engine" not in body or "Health scoring" not in body or "Adaptive roadmap update" not in body:
        s=s[:m.start("body")] + want + s[m.end("body"):]
else:
    # Bölmə yoxdur — sonuna əlavə et
    if not s.endswith("\n"): s+="\n"
    s += "\n## 40–60 Conductor\n"+want
p.write_text(s, encoding="utf-8")
print("✅ ROADMAP 40-60 section ensured")
