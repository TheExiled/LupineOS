#!/bin/bash
set -eou pipefail
set -x # Enable verbose debugging

# --- 1. FORCE ENABLE REPOS ("The Core Fix") ---
echo ">> Force Enabling Fedora Repos..."
sed -i 's/enabled=0/enabled=1/g' /etc/yum.repos.d/fedora.repo
sed -i 's/enabled=0/enabled=1/g' /etc/yum.repos.d/fedora-updates.repo

# --- 2. INSTALL CORE TOOLS (RPMs) ---
echo ">> Installing Core RPMs..."
rpm-ostree install -y \
    git zsh util-linux-user stow \
    neovim distrobox taskwarrior unzip

# --- 3. VENDOR BINARIES ("The Managed Fix") ---
echo ">> Installing Managed Binaries..."

# Starship
curl -sS https://starship.rs/install.sh | sh -s -- -y -b /usr/bin

# Eza
curl -L "https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz" | tar xz -C /usr/bin eza

# Yazi
curl -L "https://github.com/sxyazi/yazi/releases/download/v0.3.3/yazi-x86_64-unknown-linux-gnu.zip" -o /tmp/yazi.zip
unzip /tmp/yazi.zip -d /tmp/
mv /tmp/yazi-x86_64-unknown-linux-gnu/yazi /usr/bin/
rm -rf /tmp/yazi*

# Atuin
curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh -s -- -y

# Zoxide
curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh -s -- -b /usr/bin

# FZF
curl -L "https://github.com/junegunn/fzf/releases/download/v0.55.0/fzf-0.55.0-linux_amd64.tar.gz" | tar xz -C /usr/bin fzf

# Bat
curl -L "https://github.com/sharkdp/bat/releases/download/v0.24.0/bat-v0.24.0-x86_64-unknown-linux-musl.tar.gz" | tar xz --strip-components=1 -C /usr/bin */bat

# Ripgrep
curl -L "https://github.com/BurntSushi/ripgrep/releases/download/14.1.0/ripgrep-14.1.0-x86_64-unknown-linux-musl.tar.gz" | tar xz --strip-components=1 -C /usr/bin */rg

# FD
curl -L "https://github.com/sharkdp/fd/releases/download/v10.2.0/fd-v10.2.0-x86_64-unknown-linux-musl.tar.gz" | tar xz --strip-components=1 -C /usr/bin */fd

echo ">> Native Installation Complete."
