#!/usr/bin/env python3
import subprocess, os, datetime

def sh(cmd):
    return subprocess.check_output(cmd, shell=True, text=True).strip()

def last_tag():
    try:
        return sh("git describe --tags --abbrev=0")
    except subprocess.CalledProcessError:
        return ""

tag = last_tag()
rng = f"{tag}..HEAD" if tag else ""
log_cmd = f"git log --pretty=format:'- %h %s (%an)' {rng}".strip()
try:
    out = sh(log_cmd)
except subprocess.CalledProcessError:
    out = ""

ts = datetime.datetime.now().strftime("%Y-%m-%d")
header = f"# Changelog — {ts}\n\n"
if tag:
    header += f"Changes since **{tag}**:\n\n"
else:
    header += "Initial changelog:\n\n"

content = header + (out + "\n" if out else "- No changes recorded.\n")
os.makedirs("docs", exist_ok=True)
with open("docs/CHANGELOG.md","w",encoding="utf-8") as f: f.write(content)
print("✅ Changelog → docs/CHANGELOG.md")
