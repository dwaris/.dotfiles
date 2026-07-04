#!/usr/bin/env bash

MONITOR="LG Electronics LG HDR 4K 0x00002991"
MONITOR_DESC="desc:$MONITOR"
MONITOR_DESC_LONG="description: $MONITOR"

# Check if the monitor is currently active
if hyprctl monitors | grep -q "$MONITOR_DESC_LONG"; then
    # Disable the monitor using eval for hyprland-lua
    hyprctl eval "hl.monitor({output='$MONITOR_DESC', disabled=true})"
    notify-send -u low "Hyprland" "Second monitor disabled"
else
    # Reloading Hyprland configuration will re-enable the monitor with its original settings
    hyprctl reload
    notify-send -u normal "Hyprland" "Second monitor enabled"
fi
