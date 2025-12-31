#!/bin/bash
set -e

echo "🕵️ Initializing Privacy Vault (privacy)..."

# 1. Create the Container (Debian Stable for maximum reliability/trust)
distrobox create --name privacy --image debian:stable --yes

# 2. Install Privacy Tools
# Tor, Tor Browser Launcher, Mat2 (Metadata Anonymisation), OnionCircuits
distrobox enter privacy -- sudo apt-get update
distrobox enter privacy -- sudo apt-get install -y \
    tor torbrowser-launcher \
    mat2 secure-delete gocryptfs \
    git curl gpg

# 3. Setup aliases/exports if needed
# We don't export Tor Browser by default to keep it contained, 
# but we can hint the user.

echo "✅ Privacy Vault Ready."
echo "   Run 'distrobox enter privacy' to usage."
echo "   Launch Tor Browser: 'torbrowser-launcher'"
