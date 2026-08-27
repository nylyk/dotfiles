#!/usr/bin/env bash

exec swayidle -w \
  timeout 600 'hyprctl dispatch "hl.dsp.dpms({ action = \"off\" })"' \
  resume 'hyprctl dispatch "hl.dsp.dpms({ action = \"on\" })"'
