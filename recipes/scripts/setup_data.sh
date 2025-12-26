#!/bin/bash
set -e

echo "📊 Initializing Data Science Container (lab)..."

# 1. Create Container (Fedora base for stability/compatibility)
distrobox create --name lab --image fedora:latest --yes

# 2. Install Data Tools
# visidata: Terminal spreadsheet viewer
# pandoc: Document converter
# postgresql/sqlite: DB clients
echo "📥 Installing packages..."
distrobox enter lab -- sudo dnf install -y \
    visidata pandoc postgresql sqlite \
    python3-pip zsh git wget

# 3. Install Jupyter (Python)
echo "🐍 Installing Jupyter Notebook..."
distrobox enter lab -- pip3 install notebook pandas

# 4. Bridge the Shell (Zsh Sync)
echo "bridge"
distrobox enter lab -- sh -c "sudo chsh -s /usr/bin/zsh $USER"
# (Optional) If you have a shared config script, source it here. 
# For now, we assume your .zshrc works because it is in /home

echo "✅ Data Container Ready. Type 'distrobox enter lab' to deploy."
