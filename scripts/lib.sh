#!/usr/bin/env bash
# shellcheck shell=bash
set -Eeuo pipefail

# --- TTY PARACHUTE: çıxışda terminalı bərpa et ---
restore_tty() {
  { stty sane; } 2>/dev/null || true
  { tput sgr0; } 2>/dev/null || true
}
trap restore_tty EXIT

# --- Rəngləri yalnız TTY + tput varsa aç ---
_use_color() {
  [ -t 1 ] || return 1
  command -v tput >/dev/null 2>&1 || return 1
  tput setaf 2 >/dev/null 2>&1 || return 1
  return 0
}

if _use_color; then
  BOLD="$(tput bold)"; DIM="$(tput dim)"; RESET="$(tput sgr0)"
  RED="$(tput setaf 1)"; GREEN="$(tput setaf 2)"; YELLOW="$(tput setaf 3)"; BLUE="$(tput setaf 4)"
else
  BOLD=""; DIM=""; RESET=""; RED=""; GREEN=""; YELLOW=""; BLUE=""
fi

LOG_FILE=""

log_init() {  # $1 = path
  LOG_FILE="$1"
  : >"$LOG_FILE"
}

_strip_ansi() { sed -E 's/\x1b\[[0-9;]*m//g'; }

_log_write() {  # prints to stdout and appends to log
  printf "%b" "$1"
  if [ -n "${LOG_FILE:-}" ]; then
    printf "%b" "$1" | _strip_ansi >>"$LOG_FILE"
  fi
}

section() { _log_write "${BOLD}== $* ==${RESET}\n"; }
info()    { _log_write "• $*\n"; }
ok()      { _log_write "${GREEN}✓${RESET} $*\n"; }
warn()    { _log_write "${YELLOW}⚠${RESET} $*\n"; }
fail()    { _log_write "${RED}✗${RESET} $*\n"; }
hr()      { _log_write "${DIM}────────────────────────────────────${RESET}\n"; }

