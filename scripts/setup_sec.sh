#!/bin/bash
set -e # Exit immediately if a command fails

echo "💀 Initializing Cybersecurity Container (sec)..."

# 1. Create the Container
distrobox create --name sec --image kalilinux/kali-rolling --yes

# 2. Install The Arsenal & Shell Tools
# We pass commands into the container using '--'
distrobox enter sec -- sudo apt-get update
distrobox enter sec -- sudo apt-get install -y \
    kali-linux-headless \
    burpsuite seclists \
    zsh git curl iproute2

# 3. Unlock Network Hardware (Wireshark Permissions)
echo "🔓 Unlocking network card permissions..."
distrobox enter sec -- sudo usermod -aG wireshark $USER
distrobox enter sec -- sudo setcap cap_net_raw,cap_net_admin=eip /usr/bin/dumpcap

# 4. Bridge the Shell (Zsh Sync)
echo "🌉 Bridging Terminal Environment..."
distrobox enter sec -- sh -c "sudo chsh -s /usr/bin/zsh $USER"

echo "✅ Security Container Ready. Type 'distrobox enter sec' to deploy."
