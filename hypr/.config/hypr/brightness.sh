#!/usr/bin/env bash

# Adjusts DP-1's backlight over DDC/CI.
#
# Reading the current value costs ~8s, so the target is tracked in a state file
# instead. Presses coalesce: each one updates the target and returns, while a
# single writer applies the newest value, so holding the key stays responsive.

set -u

SN=5744900056166
STEP=20
STATE="${XDG_RUNTIME_DIR:-/tmp}/ddc-brightness-$SN"
DDC=(ddcutil --sn "$SN" --noverify --sleep-multiplier 0.5)

seed() {
  [ -f "$STATE" ] && return
  local cur
  cur=$("${DDC[@]}" getvcp 10 2>/dev/null | grep -oE 'current value = *[0-9]+' | grep -oE '[0-9]+$')
  printf '%s\n' "${cur:-50}" >"$STATE"
}

case "${1-}" in
  init) seed; exit 0 ;;
  up | down) ;;
  *) echo "usage: ${0##*/} up|down|init" >&2; exit 1 ;;
esac

seed

exec 8>"$STATE.target.lock"
flock 8
target=$(<"$STATE")
[ "$1" = up ] && target=$((target + STEP)) || target=$((target - STEP))
((target > 100)) && target=100
((target < 0)) && target=0
printf '%s\n' "$target" >"$STATE"
exec 8>&-

exec 9>"$STATE.write.lock"
flock -n 9 || exit 0

applied=""
while :; do
  want=$(<"$STATE")
  [ "$want" = "$applied" ] && break
  "${DDC[@]}" setvcp 10 "$want" >/dev/null 2>&1
  applied=$want
done
