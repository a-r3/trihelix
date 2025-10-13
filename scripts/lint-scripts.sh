#!/usr/bin/env bash
# shellcheck shell=bash
set -Eeuo pipefail
ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
OUT="$ROOT/out"; mkdir -p "$OUT"
. "$ROOT/scripts/lib.sh"

TXT="$OUT/shellcheck.txt"
MD="$OUT/shellcheck.md"
log_init "$TXT"
: >"$MD"

section "Shell Lint Report ($(date '+%Y-%m-%dT%H:%M:%S%z'))"

if ! command -v shellcheck >/dev/null 2>&1; then
  warn "shellcheck quraşdırılmayıb. Ubuntu: sudo apt-get install -y shellcheck"
  exit 0
fi

# Fayl siyahısı
mapfile -t FILES < <(git ls-files 'scripts/*.sh' 'modules/*/bin/*.sh' 2>/dev/null || true)
[ "${#FILES[@]}" -eq 0 ] && mapfile -t FILES < <(find scripts modules -type f -name '*.sh' 2>/dev/null || true)

if [ "${#FILES[@]}" -eq 0 ]; then
  warn "lint ediləcək *.sh tapılmadı"
  exit 0
fi

info "Fayllar: ${#FILES[@]}"
hr
total=0
bad=0

printf "# Shell Lint Report\n\n" >>"$MD"

for f in "${FILES[@]}"; do
  # gcc format sadə, stabildir
  out="$(shellcheck -f gcc "$f" 2>&1 || true)"
  if [ -n "$out" ]; then
    fail "$f"
    printf "%s\n" "$out" >>"$TXT"
    printf "- [ ] %s\n" "$f" >>"$MD"
    bad=$((bad+1))
  else
    ok "$f"
    printf "- [x] %s\n" "$f" >>"$MD"
  fi
  total=$((total+1))
done

hr
if [ "$bad" -gt 0 ]; then
  warn "Tapılan fayl(lar): $bad/$total  (detal: $TXT, $MD)\n"
else
  ok "Heç bir lint problemi yoxdur ($total fayl)\n"
fi
