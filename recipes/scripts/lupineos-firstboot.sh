#!/bin/bash
set -ouex pipefail

# LupineOS First Boot Setup
# This script runs once on the first boot of the system.

echo "🐺 LupineOS First Boot Initialization..."

# 1. Enable Flathub (System-wide)
if ! flatpak remote-list | grep -q "flathub"; then
    echo "   -> Enabling Flathub Repository..."
    flatpak remote-add --if-not-exists --system flathub https://dl.flathub.org/repo/flathub.flatpakrepo
fi

echo "✅ First Boot Complete."
