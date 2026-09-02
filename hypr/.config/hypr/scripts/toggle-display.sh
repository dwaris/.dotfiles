#!/usr/bin/env bash

# Auto-detect internal/primary screen and external/secondary screen
INTERNAL=$(hyprctl monitors all | awk '/^Monitor eDP/ {print $2}' | head -n 1)
if [ -z "$INTERNAL" ]; then
    INTERNAL=$(hyprctl monitors all | awk '/^Monitor / {print $2}' | head -n 1)
    EXTERNAL=$(hyprctl monitors all | awk '/^Monitor / {print $2}' | sed -n '2p')
else
    EXTERNAL=$(hyprctl monitors all | awk '/^Monitor / && !/^Monitor eDP/ {print $2}' | head -n 1)
fi

if [ -z "$EXTERNAL" ]; then
    notify-send -u low "Displays" "No external display detected"
    exit 0
fi

# Function to extend displays to the right (preserves calibrated scale & mode)
apply_extend_right() {
    hyprctl eval "hl.monitor({output='$INTERNAL', disabled=false})" >/dev/null
    hyprctl eval "hl.monitor({output='$EXTERNAL', disabled=false, mirror='', position='auto-right'})" >/dev/null
    notify-send -u normal "Displays" "Extended to $EXTERNAL (Right)"
}

# Function to extend displays to the left (preserves calibrated scale & mode)
apply_extend_left() {
    hyprctl eval "hl.monitor({output='$INTERNAL', disabled=false})" >/dev/null
    hyprctl eval "hl.monitor({output='$EXTERNAL', disabled=false, mirror='', position='auto-left'})" >/dev/null
    notify-send -u normal "Displays" "Extended to $EXTERNAL (Left)"
}

# Function to mirror internal display onto external
apply_mirror() {
    hyprctl eval "hl.monitor({output='$INTERNAL', disabled=false})" >/dev/null
    hyprctl eval "hl.monitor({output='$EXTERNAL', disabled=false, position='auto', mirror='$INTERNAL'})" >/dev/null
    notify-send -u normal "Displays" "Mirrored $INTERNAL to $EXTERNAL"
}

# Function to use laptop / internal display only
apply_internal_only() {
    hyprctl eval "hl.monitor({output='$INTERNAL', disabled=false})" >/dev/null
    hyprctl dispatch focusmonitor "$INTERNAL" >/dev/null
    hyprctl eval "hl.monitor({output='$EXTERNAL', disabled=true, mirror=''})" >/dev/null
    notify-send -u low "Displays" "Laptop display only ($INTERNAL)"
}

# Function to use external display only (clamshell mode)
apply_external_only() {
    hyprctl eval "hl.monitor({output='$EXTERNAL', disabled=false, mirror='', position='0x0'})" >/dev/null
    hyprctl dispatch focusmonitor "$EXTERNAL" >/dev/null
    hyprctl eval "hl.monitor({output='$INTERNAL', disabled=true})" >/dev/null
    notify-send -u normal "Displays" "External only ($EXTERNAL)"
}

# Function to restore original monitors.lua configuration
apply_reset() {
    hyprctl eval "hl.monitor({output='$EXTERNAL', mirror='', disabled=false})" >/dev/null
    hyprctl eval "hl.monitor({output='$INTERNAL', disabled=false})" >/dev/null
    hyprctl reload >/dev/null
    notify-send -u normal "Displays" "Default layout restored"
}

# If called with --cycle, cycle through: Extend (Right) -> Mirror -> Internal Only
if [ "$1" = "--cycle" ]; then
    if ! hyprctl monitors | grep -q "^Monitor $EXTERNAL "; then
        apply_extend_right
    elif hyprctl monitors all | grep -A 25 "^Monitor $EXTERNAL " | grep -q "mirrorOf: $INTERNAL"; then
        apply_internal_only
    else
        apply_mirror
    fi
    exit 0
fi

# Default: Interactive Rofi menu
OPTIONS="➡️  Extend (Right)\n⬅️  Extend (Left)\n🔁  Mirror (Clone)\n💻  Laptop/Primary Only\n🖥️  External Only\n🔄  Default / Reset"
CHOICE=$(echo -e "$OPTIONS" | rofi -dmenu -p "Display" -i)

case "$CHOICE" in
    *"Extend (Right)"*)
        apply_extend_right
        ;;
    *"Extend (Left)"*)
        apply_extend_left
        ;;
    *"Mirror"*)
        apply_mirror
        ;;
    *"Laptop/Primary Only"*)
        apply_internal_only
        ;;
    *"External Only"*)
        apply_external_only
        ;;
    *"Default / Reset"*)
        apply_reset
        ;;
esac
