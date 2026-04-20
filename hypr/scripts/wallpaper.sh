#!/bin/bash

# select a wallpaper random
NEW_WP=$(ls $HOME/Wallpapers | shuf -n 1)

# path
WALLPAPER_PATH="$HOME/Wallpapers/$NEW_WP"

# Config
HYPRPAPER_CONFIG="$HOME/.config/hypr/hyprpaper.conf"

# Clean old config
echo "" > "$HYPRPAPER_CONFIG"

# Set new wallpaper
echo "wallpaper {
  monitor=
  path = $WALLPAPER_PATH
  fit_mode = cover
}" >> "$HYPRPAPER_CONFIG"

# Reload Hyprland
pkill hyprpaper
hyprpaper &