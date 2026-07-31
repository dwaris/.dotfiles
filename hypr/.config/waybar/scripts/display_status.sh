#!/usr/bin/env bash

RAW=$(hyprctl monitors all 2>/dev/null)
if [ -z "$RAW" ]; then
    echo '{"text": "", "class": "none"}'
    exit 0
fi

# Detect primary monitor (eDP laptop screen first, otherwise ID 0, fallback first monitor)
PRIMARY=$(echo "$RAW" | awk '/^Monitor eDP/ {print $2; exit}')
[ -z "$PRIMARY" ] && PRIMARY=$(echo "$RAW" | awk '/^Monitor .* \(ID 0\):/ {print $2; exit}')
[ -z "$PRIMARY" ] && PRIMARY=$(echo "$RAW" | awk '/^Monitor / {print $2; exit}')

# Get secondary monitors (all non-primary outputs)
OTHER_MONITORS=$(echo "$RAW" | awk -v prim="$PRIMARY" '/^Monitor / { if ($2 != prim) print $2 }')
COUNT=$(echo "$OTHER_MONITORS" | grep -c .)

if [ -z "$OTHER_MONITORS" ] || [ "$COUNT" -eq 0 ]; then
    # Output empty string so Waybar automatically hides the widget on single monitor
    echo '{"text": "", "class": "single"}'
    exit 0
fi

# Function to extract monitor state
get_monitor_state() {
    local mon="$1"
    local block
    block=$(echo "$RAW" | awk -v m="$mon" '/^Monitor / { in_m = ($2 == m) } in_m { print }')
    local disabled mirror
    disabled=$(echo "$block" | awk '/disabled:/ {print $2}')
    mirror=$(echo "$block" | awk '/mirrorOf:/ {print $2}')

    if [ "$disabled" = "true" ]; then
        echo "off"
    elif [ -n "$mirror" ] && [ "$mirror" != "none" ]; then
        echo "mirror:$mirror"
    else
        echo "extend"
    fi
}

if [ "$COUNT" -eq 1 ]; then
    SECONDARY="$OTHER_MONITORS"
    STATE=$(get_monitor_state "$SECONDARY")

    case "$STATE" in
        "off")
            echo "{\"text\": \"󰍹\", \"tooltip\": \"Primary: $PRIMARY\\nSecondary ($SECONDARY): Off\", \"class\": \"off\"}"
            ;;
        mirror:*)
            MIRROR_TARGET="${STATE#mirror:}"
            echo "{\"text\": \"󰍺\", \"tooltip\": \"Primary: $PRIMARY\\nSecondary ($SECONDARY): Mirroring $MIRROR_TARGET\", \"class\": \"mirror\"}"
            ;;
        *)
            echo "{\"text\": \"󰍹\", \"tooltip\": \"Primary: $PRIMARY\\nSecondary ($SECONDARY): Extended\", \"class\": \"extend\"}"
            ;;
    esac
else
    TOOLTIP="Primary: $PRIMARY\\nOther Monitors:"
    for M in $OTHER_MONITORS; do
        STATE=$(get_monitor_state "$M")
        case "$STATE" in
            "off")      TOOLTIP="${TOOLTIP}\\n • $M: Off" ;;
            mirror:*)  TOOLTIP="${TOOLTIP}\\n • $M: Mirroring ${STATE#mirror:}" ;;
            *)          TOOLTIP="${TOOLTIP}\\n • $M: Extended" ;;
        esac
    done

    echo "{\"text\": \"󰍺\", \"tooltip\": \"$TOOLTIP\", \"class\": \"multi\"}"
fi
