#!/bin/bash

set -e  # exit on error (optional but helpful)

# Folder for wallpapers
WALLDIR="$HOME/.config/hypr/wallpapers"

# Make sure the folder exists
if [ ! -d "$WALLDIR" ]; then
    notify-send "Wallpaper chooser" "Folder not found: $WALLDIR"
    exit 1
fi

# Let user pick a wallpaper via rofi
CHOICE=$(find "$WALLDIR" -maxdepth 1 -type f \
  \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) \
  | sed "s|$WALLDIR/||" \
  | sort \
  | rofi -dmenu -p "Wallpaper")

# If user pressed Esc or nothing chosen, exit
[ -z "$CHOICE" ] && exit 0

WALLPATH="$WALLDIR/$CHOICE"

# Double-check file exists
if [ ! -f "$WALLPATH" ]; then
    notify-send "Wallpaper chooser" "File not found: $WALLPATH"
    exit 1
fi

# Preload the image so the switch is immediate
hyprctl hyprpaper preload "$WALLPATH"

# Get all monitors
MONITORS=$(hyprctl monitors -j | jq -r '.[].name')

# Set this wallpaper on every monitor
for MON in $MONITORS; do
    hyprctl hyprpaper wallpaper "$MON,$WALLPATH"
done

wallust run $WALLPATH
