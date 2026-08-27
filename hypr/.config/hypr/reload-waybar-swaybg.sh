#!/usr/bin/env bash

killall waybar
killall swaybg

waybar & swaybg -i ~/.config/wallpaper -m fill
