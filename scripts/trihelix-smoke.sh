#!/usr/bin/env bash
# shellcheck shell=bash
set -Eeuo pipefail

# Pager/ANSI off – terminalı “tutmasın”
export GH_PAGER=cat
export PAGER=cat
export CLICOLOR_FORCE=0
export TERM="${TERM:-dumb}"

ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
OUT="$ROOT/out"; mkdir -p "$OUT"
INV_TXT="$OUT/inventory.txt"
INV_MD="$OUT/inventory.md"

. "$ROOT/scripts/lib.sh"
log_init "$INV_TXT"
: >"$INV_MD"

section "TriHelix Smoke ($(date '+%Y-%m-%dT%H:%M:%S%z'))"

ok_files=1
for f in ".github/workflows/release.yml" "docs/RELEASE_NOTES.md" "docs/CHANGELOG.md"; do
  if [ -f "$ROOT/$f" ]; then ok "$f"; echo "- [x] $f" >>"$INV_MD"
  else ok_files=0; fail "$f yoxdur"; echo "- [ ] $f (missing)" >>"$INV_MD"; fi
done
hr

ver=""
if [ -f "$ROOT/CONTEXT.yaml" ]; then
  ver="$(awk '/^version:/{print $2;exit}' "$ROOT/CONTEXT.yaml" || true)"
  [ -n "$ver" ] && ok "CONTEXT.yaml version: $ver" || warn "CONTEXT.yaml var, version tapılmadı"
else
  warn "CONTEXT.yaml tapılmadı"
fi
printf "\nVersion: \`%s\`\n" "$ver" >>"$INV_MD"
hr

if command -v gh >/dev/null 2>&1; then
  if gh workflow view release.yml >/dev/null 2>&1; then ok "GitHub workflow release.yml əlçatandır (gh)"
  else warn "gh workflow view release.yml alınmadı"; fi
else
  info "gh quraşdırılmayıb (skip)"
fi

hr
if [ "$ok_files" -eq 1 ]; then
  ok "Smoke: PASS"
  printf "\nResult: ✅ PASS\n" >>"$INV_MD"
else
  fail "Smoke: FAIL"
  printf "\nResult: ❌ FAIL\n" >>"$INV_MD"
fi
info "Detallar: $INV_TXT, $INV_MD"

