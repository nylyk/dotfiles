#!/usr/bin/env bash

# Builds an Xcursor theme from a set of Windows .ani/.cur cursors.
#
# The cursor files themselves are not in this repo -- they may not be
# redistributed or modified (https://colorfulstage.com/media/download/).
# Download a cursor zip from there yourself, then:
#
#   ./install-cursors.sh ~/Downloads/cursors.zip
#
# Requires win2xcur.

set -euo pipefail

THEME="ProjectSekai"
DEST="$HOME/.local/share/icons/$THEME"

if [ $# -ne 1 ]; then
  echo "usage: $0 <cursor-zip-or-directory>" >&2
  exit 1
fi

if ! command -v win2xcur >/dev/null; then
  echo "win2xcur not found -- see https://github.com/quantum5/win2xcur" >&2
  exit 1
fi

src="$1"
tmp=""
if [ -f "$src" ]; then
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT
  unzip -q -j "$src" -d "$tmp"
  src="$tmp"
fi

shopt -s nullglob nocaseglob
cursors=("$src"/*.ani "$src"/*.cur)
shopt -u nocaseglob
if [ ${#cursors[@]} -eq 0 ]; then
  echo "no .ani or .cur files found in $1" >&2
  exit 1
fi

rm -rf "$DEST"
mkdir -p "$DEST/cursors"
win2xcur "${cursors[@]}" -o "$DEST/cursors"

cat >"$DEST/index.theme" <<EOF
[Icon Theme]
Name=$THEME
Comment=Project Sekai cursors
EOF

cd "$DEST/cursors"

# Apps request X11/CSS names, not the Windows role names win2xcur produces.
# The hex names are what Chromium, Firefox and GTK actually look up.
link() {
  local src="$1"
  shift
  if [ ! -e "$src" ]; then
    echo "warning: no '$src' cursor in this set, skipping ${#@} names" >&2
    return
  fi
  for name in "$@"; do
    [ "$name" = "$src" ] || ln -sfn "$src" "$name"
  done
}

link Normal \
  default left_ptr arrow top_left_arrow right_ptr left_arrow \
  copy alias link context-menu dnd-copy dnd-link dnd-none X_cursor x-cursor

link Link \
  pointer hand hand1 hand2 pointing_hand grab openhand \
  e29285e634086352946a0e7090d73106 9d800788f1b08800ae810202380a0822

link Text \
  text xterm ibeam vertical-text

link Help \
  help question_arrow whats_this left_ptr_help \
  d9ce0ab605698f320427677b458ad60b 5c6cd98b3f3ebcb1f9c7f1c204630408

link Working \
  progress left_ptr_watch half-busy \
  00000000000000020006000e7e9ffc3f 08e8e1c95fe2fc01f976f1e063a24ccd \
  3ecb610c1bf2410f44200f48c40d3599

link Busy \
  wait watch 0426c94ea35c87780ff01dc239897213

link Precision \
  crosshair cross tcross cross_reverse diamond_cross cell plus \
  zoom-in zoom-out color-picker dotbox draped_box target icon

link Handwriting \
  pencil draft

link Unavailable \
  not-allowed no-drop forbidden crossed_circle circle dnd-no-drop \
  03b6e0fcb3499374a867c041f52298f0

link Move \
  move all-scroll fleur size_all grabbing closedhand dnd-move \
  4498f0e0c1937ffe01fd06f973665830 9081237383d90e509aa00f00170e968f \
  fcf21c00b30f7e3f83fe0dfd12e71cff

# Horizontal/Vertical also cover the window edge names used when resizing.
link Horizontal \
  ew-resize col-resize e-resize w-resize \
  sb_h_double_arrow h_double_arrow size_hor split_h left_side right_side \
  028006030e0e7ebffc7f7070c0600140 14fef782d02440884392942c11205230

link Vertical \
  ns-resize row-resize n-resize s-resize \
  sb_v_double_arrow v_double_arrow size_ver split_v top_side bottom_side \
  00008160000006810000408080010102 2870a09082c103050810ffdffffe0204

# Diagonal1 is "\" (NW-SE), Diagonal2 is "/" (NE-SW). If window corners
# resize with the arrow pointing the wrong way, swap these two blocks.
link Diagonal1 \
  nwse-resize nw-resize se-resize size_fdiag bd_double_arrow \
  top_left_corner bottom_right_corner \
  c7088f0f3e6c8088236ef8e1e3e70000 38c5dff7c7b8962045400281044508d2

link Diagonal2 \
  nesw-resize ne-resize sw-resize size_bdiag fd_double_arrow \
  top_right_corner bottom_left_corner \
  fcf1c3c7cd4491d801f1e1c78f100000 50585d75b494802d0151028115016902

link Alternate \
  up_arrow center_ptr sb_up_arrow

# Person and Pin are Windows 11-only roles with no X11 equivalent.

echo "installed $THEME: $(find . -maxdepth 1 -type f | wc -l) cursors, $(find . -maxdepth 1 -type l | wc -l) names"
echo
echo "set these in your environment to use it:"
echo "  XCURSOR_THEME=$THEME"
echo "  XCURSOR_SIZE=24"
