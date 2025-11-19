#!/bin/bash

WALLDIR="$HOME/.config/hypr/wallpapers"
MONITOR=$(hyprctl monitors -j | jq -r '.[0].name')
RANDOM_WALL=$(ls "$WALLDIR" | shuf -n 1)

hyprctl hyprpaper wallpaper wallust "$MONITOR, $WALLDIR/$RANDOM_WALL"
