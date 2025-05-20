#!/bin/bash
# Get volume information from wpctl
volume_info=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)

# Check if muted
if echo "$volume_info" | grep -q "MUTED"; then
  notify-send --app-name="Volume" "<b>volume:0</b>" \
    -h string:x-canonical-private-synchronous:volume \
    -h int:value:"0" \
    -t 2000
  exit 0
fi

# Extract current volume percentage
current=$(echo "$volume_info" | grep -oP 'Volume: [0-9].[0-9]+' | awk '{print int($2 * 100)}')

# Using notify-send with just bold text and progress bar
notify-send --app-name="Volume" "<b>$current</b>" \
  -h string:x-canonical-private-synchronous:volume \
  -h int:value:"$current" \
  -t 2000
