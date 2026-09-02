#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/Nextcloud/Media/Wallpaper"

FILES=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \))

ROFI_INPUT=""
while read -r file; do
    filename=$(basename "$file")
    ROFI_INPUT+="${filename}\0icon\x1f${file}\n"
done <<< "$FILES"

SELECTED_NAME=$(echo -en "$ROFI_INPUT" | rofi -dmenu -i -show-icons -p "Wallpaper" \
    -theme-str 'window {width: 60%;}' \
    -theme-str 'listview {columns: 4; lines: 3; fixed-columns: true;}' \
    -theme-str 'element {orientation: vertical; padding: 5px;}' \
    -theme-str 'element-icon {size: 15em;}' \
    -theme-str 'element-text {horizontal-align: 0.5;}')

if [ -n "$SELECTED_NAME" ]; then
    SELECTED_IMAGE=$(echo "$FILES" | grep "/$SELECTED_NAME$" | head -n 1)
    
    if [ -n "$SELECTED_IMAGE" ]; then
        awww img "$SELECTED_IMAGE" --transition-type any --transition-fps 60 --transition-duration 1.5
    fi
fi
