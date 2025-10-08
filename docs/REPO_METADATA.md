# Repository Metadata

- Default branch: **main**
- CI: `.github/workflows/trihelix-ci.yml` (loop → PR)
- Release: `.github/workflows/release.yml` (draft notes + tag + GitHub Release)
- Labels: `.github/labels.yml` + workflow `sync-labels`
- Owners: `.github/CODEOWNERS`
- Templates: `.github/PULL_REQUEST_TEMPLATE.md`, `.github/ISSUE_TEMPLATE/*`

## How to use

```bash
# Sync labels (once)
gh workflow run sync-labels

# Draft a release with tag v0.1.0
gh workflow run trihelix-release -f version=v0.1.0

# Or bump version in CONTEXT.yaml locally
bash scripts/version-bump.sh 1.0.1 && git add -A && git commit -m "chore: bump version" && git push
```
