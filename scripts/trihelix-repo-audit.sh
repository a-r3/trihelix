#!/usr/bin/env bash
# shellcheck shell=bash
set -Eeuo pipefail
ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
OUT="$ROOT/out"; mkdir -p "$OUT"
LOG="$OUT/audit.txt"

. "$ROOT/scripts/lib.sh"
log_init "$LOG"

section "TriHelix Repo Audit @ $(date '+%Y-%m-%dT%H:%M:%S%z')"
info "root: $ROOT"
hr

section "git status"
git status -sb 2>/dev/null | sed 's/^/  /'
hr

section "rebase / stash"
if [ -d "$ROOT/.git/rebase-merge" ] || [ -d "$ROOT/.git/rebase-apply" ]; then
  warn "active rebase var"
else
  ok "rebase yoxdur"
fi
git stash list 2>/dev/null | sed 's/^/  /'
hr

section "CI/workflows"
if [ -f "$ROOT/.github/workflows/release.yml" ]; then ok ".github/workflows/release.yml var"; else fail "release.yml yoxdur"; fi
hr

section "docs stubs"
for f in docs/RELEASE_NOTES.md docs/CHANGELOG.md; do
  if [ -f "$ROOT/$f" ]; then ok "$f"; else warn "$f yoxdur"; fi
done
hr

section "large files (>5MB)"
find "$ROOT" -type f -size +5M \
  -not -path '*/.git/*' -not -path '*/.helix/*' -not -path '*/modules/*/out/*' \
  -print 2>/dev/null | sed 's/^/  /' || true
hr

section "simple secret scan"
grep -R --line-number -E '(ghp_[A-Za-z0-9]{36,}|AWS_(SECRET|ACCESS)|-----BEGIN (RSA|EC) PRIVATE KEY-----)' \
  "$ROOT" 2>/dev/null | sed 's/^/  /' || info "(tapılmadı)"
hr

section "branch protection (token olarsa)"
if [ -n "${GITHUB_TOKEN:-}" ] && command -v curl >/dev/null 2>&1 && command -v jq >/dev/null 2>&1; then
  OWNER="${OWNER:-a-r3}"; REPO="${REPO:-trihelix}"
  curl -s -H "Authorization: token ${GITHUB_TOKEN}" -H "Accept: application/vnd.github+json" \
    "https://api.github.com/repos/$OWNER/$REPO/branches/main/protection" \
  | jq -r '{strict:.required_status_checks.strict,contexts:.required_status_checks.contexts,reviews:(.required_pull_request_reviews.required_approving_review_count)}' 2>/dev/null \
  | sed 's/^/  /'
else
  info "(skip: token və ya curl/jq yoxdur)"
fi

hr
ok "Audit tamamlandı → $LOG"
