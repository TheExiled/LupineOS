#!/bin/bash
set -ouex pipefail

# Make sure our scripts in /opt are executable
chmod +x /opt/lupineos/scripts/*.sh

# Set ZSH as default for new users (optional, but convenient)
# echo "Setting ZSH as default shell..."
# luseradd -s /usr/bin/zsh || true
