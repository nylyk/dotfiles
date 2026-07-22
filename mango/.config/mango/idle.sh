#!/usr/bin/env bash

MONS="DP-1 DP-2 DP-3 HDMI-A-1"

sleep_cmd=""
wake_cmd=""
for m in $MONS; do
  sleep_cmd="${sleep_cmd}mmsg dispatch sleep_monitor,${m}; "
  wake_cmd="${wake_cmd}mmsg dispatch wakeup_monitor,${m}; "
done

exec swayidle -w timeout 600 "$sleep_cmd" resume "$wake_cmd"
