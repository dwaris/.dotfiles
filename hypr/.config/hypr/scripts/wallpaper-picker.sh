#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/Nextcloud/Media/Wallpaper"

FILES=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \))

ROFI_INPUT=""
while read -r file; do
    filename=$(basename "$file")
    ROFI_INPUT+="${filename}\0icon\x1f${file}\n"
done <<< "$FILES"

SELECTED_NAME=$(echo -en "$ROFI_INPUT" | rofi -dmenu -i -show-icons -p "Wallpaper" \
    -theme-str 'window {width: 48%; border-radius: 10px;}' \
    -theme-str 'listview {columns: 1; lines: 7; fixed-height: true; spacing: 6px; padding: 10px;}' \
    -theme-str 'element {orientation: horizontal; padding: 6px 12px; border-radius: 6px; spacing: 14px;}' \
    -theme-str 'element-icon {size: 4.8em; border-radius: 4px;}' \
    -theme-str 'element-text {vertical-align: 0.5; font: "BlexMono Nerd Font Propo 12";}')

if [ -n "$SELECTED_NAME" ]; then
    SELECTED_IMAGE=$(echo "$FILES" | grep "/$SELECTED_NAME$" | head -n 1)
    
    if [ -n "$SELECTED_IMAGE" ]; then
        hyprctl hyprpaper preload "$SELECTED_IMAGE"
        hyprctl hyprpaper wallpaper ",$SELECTED_IMAGE"
    fi
fi
