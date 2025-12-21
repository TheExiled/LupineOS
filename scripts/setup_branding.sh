#!/bin/bash
# setup_branding.sh
# Purpose: Deploys LupineOS wallpapers and visual assets.

REPO_ROOT="$HOME/LupineOS"
TARGET_DIR="$HOME/Pictures/LupineOS_Wallpapers"
DEFAULT_WALLPAPER="lupine_default.jpg"

echo "🎨 Initializing LupineOS Branding..."

# 1. Create the local wallpaper directory
if [ ! -d "$TARGET_DIR" ]; then
    echo "   -> Creating wallpaper directory: $TARGET_DIR"
    mkdir -p "$TARGET_DIR"
fi

# 2. Copy assets from Repo to Home
# We use rsync or cp to move the images
if [ -d "$REPO_ROOT/assets/wallpapers" ]; then
    echo "   -> Installing wallpapers..."
    cp "$REPO_ROOT/assets/wallpapers/"* "$TARGET_DIR/"
else
    echo "   ⚠️  No wallpapers found in $REPO_ROOT/assets/wallpapers/"
fi

# 3. Suggest the user sets the wallpaper
# (Automatic setting via CLI is unstable in COSMIC Alpha right now)
echo "   ✅ Wallpapers installed to $TARGET_DIR"
echo "   ℹ️  To apply: Right-click Desktop -> Settings -> Desktop -> Background"
echo "       Select 'Add Picture' and choose: $TARGET_DIR/$DEFAULT_WALLPAPER"
