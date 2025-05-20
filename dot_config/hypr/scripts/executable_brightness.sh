#!/bin/bash
# Get brightness information from brightnessctl
brightness_info=$(brightnessctl info)
# Extract current brightness percentage
current=$(echo "$brightness_info" | grep -oP '\(([0-9]+)%\)' | grep -oP '[0-9]+')

# Using notify-send with just bold text and progress bar
notify-send --app-name="Brightness" "<b>$current</b>" \
  -h string:x-canonical-private-synchronous:brightness \
  -h int:value:"$current" \
  -t 2000
