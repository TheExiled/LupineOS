#!/bin/bash
set -e

echo "📦 Initializing Sandbox Container (arch)..."

# 1. Create Container (Arch Linux)
distrobox create --name arch --image archlinux:latest --yes

# 2. Install Base Devel (Required for compiling AUR packages)
echo "🔨 Installing compilation tools..."
distrobox enter arch -- sudo pacman -Syu --noconfirm base-devel git zsh neovim wget

# 3. Install 'yay' (AUR Helper)
# We must do this as a user, not root. Distrobox handles the user mapping.
echo "🚀 Installing yay (AUR Helper)..."
distrobox enter arch -- sh -c '
    if ! command -v yay &> /dev/null; then
        cd /tmp
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si --noconfirm
        cd ..
        rm -rf yay
    fi
'

# 4. Bridge the Shell
echo "🌉 Bridging Terminal Environment..."
distrobox enter arch -- sh -c "sudo chsh -s /usr/bin/zsh $USER"

echo "✅ Sandbox Ready. Type 'distrobox enter arch' to use 'yay -S package_name'."
