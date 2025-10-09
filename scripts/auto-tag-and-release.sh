#!/usr/bin/env bash
set -Eeuo pipefail

# config
DEFAULT_BUMP="${1:-patch}"   # patch|minor|major (arg1 verə bilərsən)
WORKFLOW_FILE="release.yml"  # .github/workflows/release.yml
UPDATE_CONTEXT=1

die(){ echo "ERROR: $*" >&2; exit 1; }
need(){ command -v "$1" >/dev/null || die "missing tool: $1"; }

latest_tag() { git fetch -q --tags || true; git tag -l 'v*.*.*' --sort=-v:refname | head -n1; }
bump() {
  local t="$1" kind="$2" M=0 m=1 p=0
  [[ -n "$t" ]] && { t="${t#v}"; IFS='.' read -r M m p <<<"$t"; }
  case "$kind" in major) ((M++)); m=0; p=0;; minor) ((m++)); p=0;; *) ((p++));; esac
  echo "v${M}.${m}.${p}"
}
ctx_ver() { [[ -f CONTEXT.yaml ]] && awk '/^version:/{print $2;exit}' CONTEXT.yaml || true; }
sync_ctx() {
  local v="${1#v}"; [[ "$UPDATE_CONTEXT" -ne 1 || ! -f CONTEXT.yaml ]] && return 0
  awk -v v="$v" 'BEGIN{done=0} {if(!done && $1=="version:"){print "version: " v; done=1} else print} END{if(!done) print "version: " v}' CONTEXT.yaml > CONTEXT.yaml.tmp
  mv CONTEXT.yaml.tmp CONTEXT.yaml
  git add CONTEXT.yaml; git commit -m "chore(release): sync CONTEXT.yaml -> ${v}" >/dev/null || true
}

dispatch() {
  local tag="$1" repo OWNER REPO
  need curl; [[ -n "${GITHUB_TOKEN:-}" ]] || die "GITHUB_TOKEN boşdur (repo,workflow icazəli PAT)"
  OWNER="$(git config remote.origin.url | sed -E 's@.*github.com[:/]([^/]+)/.*@\1@')"
  REPO="$(git config remote.origin.url | sed -E 's@.*/([^/]+)\.git$@\1@')"
  curl -fsS -X POST \
    -H "Authorization: token ${GITHUB_TOKEN}" \
    -H "Accept: application/vnd.github+json" \
    "https://api.github.com/repos/${OWNER}/${REPO}/actions/workflows/${WORKFLOW_FILE}/dispatches" \
    -d "{\"ref\":\"main\",\"inputs\":{\"version\":\"${tag}\"}}"
}

# preflight
need git
[[ -d .git ]] || die "run from repo root"
git diff --quiet && git diff --cached --quiet || die "working tree dirty; commit/stash before tagging"

# compute next
L="$(latest_tag)"; C="$(ctx_ver || true)"
[[ -n "$C" && "$C" != v* ]] && C="v$C"
if [[ -z "$L" && -n "$C" ]]; then T="$C"; else T="$(bump "$L" "$DEFAULT_BUMP")"; fi

# tag & push
git tag -a "$T" -m "TriHelix $T" 2>/dev/null || true
git push origin "$T"

# sync context & push
sync_ctx "$T"; git push origin HEAD || true

# fire workflow
dispatch "$T" >/dev/null
echo "✓ Released: $T (workflow dispatched)"
