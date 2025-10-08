# Ops Polish — TriHelix

**Auto-merge:** PR-lara `automerge` label verin; checks yaşıl olarsa squash merge avtomatikdir.  
**Schedule:** `scheduled-loop.yml` hər 6 saatdan bir loop işlədir.  
**Semantic bump:** `scripts/semver-bump.sh [major|minor|patch]` versiyanı artırır; sonra `release` workflow-u ilə taglayın.  
**Changelog:** `scripts/changelog.py` → `docs/CHANGELOG.md` yaradır; release body-ə də əlavə edə bilərsiniz.  
**Rich webhook:** `scripts/notify-rich.sh` Slack/Discord uyğun mətn göndərir (NOTIFY_WEBHOOK lazımdır).

## Tipik axın
```bash
# planlı dəyişikliklər
bash scripts/semver-bump.sh minor
python3 scripts/changelog.py
git add -A && git commit -m "chore(release): bump & changelog" && git push

# release
gh workflow run trihelix-release -f version=v$(awk '/^version:/{print $2;exit}' CONTEXT.yaml)
```
