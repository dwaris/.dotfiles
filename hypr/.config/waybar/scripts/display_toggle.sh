#!/usr/bin/env bash

MODE="${1:-menu}"

RAW=$(hyprctl monitors all 2>/dev/null)
if [ -z "$RAW" ]; then
    echo "No Hyprland monitors found"
    exit 1
fi

# Detect primary monitor (eDP laptop screen first, otherwise ID 0, fallback first monitor)
PRIMARY=$(echo "$RAW" | awk '/^Monitor eDP/ {print $2; exit}')
[ -z "$PRIMARY" ] && PRIMARY=$(echo "$RAW" | awk '/^Monitor .* \(ID 0\):/ {print $2; exit}')
[ -z "$PRIMARY" ] && PRIMARY=$(echo "$RAW" | awk '/^Monitor / {print $2; exit}')

# Get secondary monitors
OTHER_MONITORS=$(echo "$RAW" | awk -v prim="$PRIMARY" '/^Monitor / { if ($2 != prim) print $2 }')
COUNT=$(echo "$OTHER_MONITORS" | grep -c .)

if [ -z "$OTHER_MONITORS" ] || [ "$COUNT" -eq 0 ]; then
    [ "$MODE" = "menu" ] && rofi -e "No extra monitors detected (Primary: $PRIMARY)"
    exit 0
fi

# Helper to apply monitor settings
set_monitor_mode() {
    local mon="$1"
    local action="$2"

    case "$action" in
        "right")
            hyprctl eval "hl.monitor({ output = '$mon', mode = 'preferred', position = 'auto-right', scale = 'auto', disabled = false, mirror = '' })" 2>/dev/null || \
            hyprctl keyword monitor "$mon,preferred,auto-right,1" 2>/dev/null
            ;;
        "left")
            hyprctl eval "hl.monitor({ output = '$mon', mode = 'preferred', position = 'auto-left', scale = 'auto', disabled = false, mirror = '' })" 2>/dev/null || \
            hyprctl keyword monitor "$mon,preferred,auto-left,1" 2>/dev/null
            ;;
        "mirror")
            hyprctl eval "hl.monitor({ output = '$mon', mode = 'preferred', position = 'auto', scale = 'auto', disabled = false, mirror = '$PRIMARY' })" 2>/dev/null || \
            hyprctl keyword monitor "$mon,preferred,auto,1,mirror,$PRIMARY" 2>/dev/null
            ;;
        "off")
            hyprctl eval "hl.monitor({ output = '$mon', disabled = true })" 2>/dev/null || \
            hyprctl keyword monitor "$mon,disable" 2>/dev/null
            ;;
    esac

    # Signal Waybar to refresh status module
    pkill -RTMIN+8 waybar 2>/dev/null || true
}

FIRST_SEC=$(echo "$OTHER_MONITORS" | head -n 1)

get_sec_attr() {
    local attr="$1"
    local block
    block=$(echo "$RAW" | awk -v sec="$FIRST_SEC" '/^Monitor / { in_sec = ($2 == sec) } in_sec { print }')
    echo "$block" | awk -v a="$attr:" '$1 == a {print $2}'
}

case "$MODE" in
    "toggle")
        # Left click: Toggle Extend Left <-> Off
        DISABLED=$(get_sec_attr "disabled")
        if [ "$DISABLED" = "true" ]; then
            set_monitor_mode "$FIRST_SEC" "left"
        else
            set_monitor_mode "$FIRST_SEC" "off"
        fi
        ;;

    "mirror")
        # Right click: Toggle Mirror Primary <-> Off
        MIRROR=$(get_sec_attr "mirrorOf")
        if [ -n "$MIRROR" ] && [ "$MIRROR" != "none" ]; then
            set_monitor_mode "$FIRST_SEC" "off"
        else
            set_monitor_mode "$FIRST_SEC" "mirror"
        fi
        ;;

    "menu")
        # Middle click: Interactive Rofi menu
        if [ "$COUNT" -eq 1 ]; then
            TARGET_MON="$OTHER_MONITORS"
        else
            MON_MENU=""
            for M in $OTHER_MONITORS; do
                MON_MENU="${MON_MENU}󰍹 Manage $M\n"
            done
            MON_MENU="${MON_MENU}󰍹 Turn Off All Extra Monitors\n󰍹 Extend All Extra Monitors"
            
            SEL=$(echo -e "$MON_MENU" | rofi -dmenu -p "Select Display")
            [ -z "$SEL" ] && exit 0
            
            if [[ "$SEL" == *"Turn Off All"* ]]; then
                for M in $OTHER_MONITORS; do set_monitor_mode "$M" "off"; done
                exit 0
            elif [[ "$SEL" == *"Extend All"* ]]; then
                for M in $OTHER_MONITORS; do set_monitor_mode "$M" "left"; done
                exit 0
            elif [[ "$SEL" == *"Manage "* ]]; then
                TARGET_MON=$(echo "$SEL" | awk '{print $NF}')
            else
                exit 0
            fi
        fi

        MENU="󰍹 Extend (Left)\n󰍹 Extend (Right)\n󰍺 Mirror / Duplicate\n󰍹 Turn Off"
        CHOICE=$(echo -e "$MENU" | rofi -dmenu -p "Configure ($TARGET_MON)")

        case "$CHOICE" in
            *"Extend (Left)"*)      set_monitor_mode "$TARGET_MON" "left" ;;
            *"Extend (Right)"*)     set_monitor_mode "$TARGET_MON" "right" ;;
            *"Mirror / Duplicate"*) set_monitor_mode "$TARGET_MON" "mirror" ;;
            *"Turn Off"*)          set_monitor_mode "$TARGET_MON" "off" ;;
        esac
        ;;
esac
