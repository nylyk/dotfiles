#!/usr/bin/env bash

input=$(cat)

{ read -r cwd; read -r model; read -r used_tokens; read -r used_pct; } < <(echo "$input" | python3 -c '
import json, sys
d = json.load(sys.stdin)
print(d.get("workspace", {}).get("current_dir") or d.get("cwd") or "")
print(d.get("model", {}).get("display_name") or "")
c = d.get("context_window", {})
t = c.get("total_input_tokens")
print("" if t is None else int(t))
p = c.get("used_percentage")
print("" if p is None else p)
')

BLUE=$'\033[34m'
MAGENTA=$'\033[35m'
GREEN=$'\033[32m'
RED=$'\033[31m'
DIM=$'\033[2m'
LIGHT=$'\033[37m'
RESET=$'\033[0m'

short_cwd="${cwd/#$HOME/\~}"
IFS='/' read -ra parts <<< "$short_cwd"
if [ "${#parts[@]}" -gt 3 ]; then
  short_cwd="${parts[-2]}/${parts[-1]}"
fi

left_plain="$short_cwd"
left="${BLUE}${short_cwd}${RESET}"

middle_plain=""
middle=""
if [ -n "$cwd" ] && git -C "$cwd" --no-optional-locks rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  branch=$(git -C "$cwd" --no-optional-locks branch --show-current 2>/dev/null)
  if [ -n "$branch" ]; then
    left_plain="${left_plain} ${branch}"
    left="${left} ${MAGENTA}${branch}${RESET}"
  fi

  stats=$(git -C "$cwd" --no-optional-locks diff --shortstat HEAD 2>/dev/null)
  if [ -n "$stats" ]; then
    files=$(echo "$stats" | grep -oE '[0-9]+ file' | grep -oE '[0-9]+')
    added=$(echo "$stats" | grep -oE '[0-9]+ insertion' | grep -oE '[0-9]+')
    removed=$(echo "$stats" | grep -oE '[0-9]+ deletion' | grep -oE '[0-9]+')
    [ -z "$added" ] && added=0
    [ -z "$removed" ] && removed=0
    middle_plain="${files} files +${added}/-${removed}"
    middle="${files} files ${GREEN}+${added}${RESET}/${RED}-${removed}${RESET}"
  fi
fi

right_plain=""
right=""
if [ -n "$model" ]; then
  right_plain="$model"
  right="${LIGHT}${model}${RESET}"
fi
ctx=""
if [ -n "$used_tokens" ] && [ "$used_tokens" -gt 0 ]; then
  ctx="$(( (used_tokens + 500) / 1000 ))k"
fi
if [ -n "$used_pct" ]; then
  pct=$(printf '%.0f' "$used_pct")
  if [ -n "$ctx" ]; then
    ctx="${ctx} (${pct}%)"
  else
    ctx="${pct}%"
  fi
fi
if [ -n "$ctx" ]; then
  if [ -n "$right" ]; then
    right_plain="${right_plain} | "
    right="${right} ${DIM}|${RESET} "
  fi
  right_plain="${right_plain}${ctx}"
  right="${right}${LIGHT}${ctx}${RESET}"
fi

MARGIN=4
width=$(( ${COLUMNS:-0} - MARGIN ))
total=$(( ${#left_plain} + ${#middle_plain} + ${#right_plain} ))

if [ "$width" -gt $(( total + 4 )) ]; then
  mid_start=$(( (width - ${#middle_plain}) / 2 ))
  pad1=$(( mid_start - ${#left_plain} ))
  [ "$pad1" -lt 2 ] && pad1=2
  pad2=$(( width - ${#left_plain} - pad1 - ${#middle_plain} - ${#right_plain} ))
  [ "$pad2" -lt 2 ] && pad2=2
  printf '%s%*s%s%*s%s\n' "$left" "$pad1" '' "$middle" "$pad2" '' "$right"
else
  out="$left"
  [ -n "$middle" ] && out="${out}  ${DIM}•${RESET}  ${middle}"
  [ -n "$right" ] && out="${out}  ${DIM}•${RESET}  ${right}"
  printf '%s\n' "$out"
fi
