#!/usr/bin/env bash

zenity --question --title "$1" --text "$2" --ok-label "$3" --cancel-label Cancel --icon "$4"

if [ $? -eq 0 ]; then
  bash -c "$5"
fi
