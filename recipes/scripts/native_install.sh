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
    neovim distrobox task unzip plymouth-plugin-script

# --- 3. VENDOR BINARIES ("The Managed Fix") ---
echo ">> Installing Managed Binaries..."

# Starship
curl -sS https://starship.rs/install.sh | sh -s -- -y -b /usr/bin

# Eza
curl -L "https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz" -o /tmp/eza.tar.gz
tar xz -f /tmp/eza.tar.gz -C /tmp
mv /tmp/eza /usr/bin/eza
chmod +x /usr/bin/eza
rm /tmp/eza.tar.gz

# Yazi
curl -L "https://github.com/sxyazi/yazi/releases/download/v0.3.3/yazi-x86_64-unknown-linux-gnu.zip" -o /tmp/yazi.zip
unzip /tmp/yazi.zip -d /tmp/
mv /tmp/yazi-x86_64-unknown-linux-gnu/yazi /usr/bin/
rm -rf /tmp/yazi*

# Atuin (Keep manual extract - script failed previously)
curl -L "https://github.com/atuinsh/atuin/releases/latest/download/atuin-x86_64-unknown-linux-gnu.tar.gz" -o /tmp/atuin.tar.gz
tar xz -f /tmp/atuin.tar.gz -C /tmp
mv /tmp/atuin-x86_64-unknown-linux-gnu/atuin /usr/bin/atuin
chmod +x /usr/bin/atuin
rm -rf /tmp/atuin*

# Zoxide
curl -L "https://github.com/ajeetdsouza/zoxide/releases/download/v0.9.6/zoxide-0.9.6-x86_64-unknown-linux-musl.tar.gz" -o /tmp/zoxide.tar.gz
tar xz -f /tmp/zoxide.tar.gz -C /tmp
mv /tmp/zoxide /usr/bin/zoxide
chmod +x /usr/bin/zoxide
rm -rf /tmp/zoxide.tar.gz

# FZF
curl -L "https://github.com/junegunn/fzf/releases/download/v0.55.0/fzf-0.55.0-linux_amd64.tar.gz" -o /tmp/fzf.tar.gz
tar xz -f /tmp/fzf.tar.gz -C /tmp
mv /tmp/fzf /usr/bin/fzf
chmod +x /usr/bin/fzf
rm -rf /tmp/fzf.tar.gz

# Bat
curl -L "https://github.com/sharkdp/bat/releases/download/v0.24.0/bat-v0.24.0-x86_64-unknown-linux-musl.tar.gz" -o /tmp/bat.tar.gz
tar xz -f /tmp/bat.tar.gz -C /tmp
mv /tmp/bat-v0.24.0-x86_64-unknown-linux-musl/bat /usr/bin/bat
chmod +x /usr/bin/bat
rm -rf /tmp/bat*

# Ripgrep
curl -L "https://github.com/BurntSushi/ripgrep/releases/download/14.1.0/ripgrep-14.1.0-x86_64-unknown-linux-musl.tar.gz" -o /tmp/rg.tar.gz
tar xz -f /tmp/rg.tar.gz -C /tmp
mv /tmp/ripgrep-14.1.0-x86_64-unknown-linux-musl/rg /usr/bin/rg
chmod +x /usr/bin/rg
rm -rf /tmp/rg*

# FD
curl -L "https://github.com/sharkdp/fd/releases/download/v10.2.0/fd-v10.2.0-x86_64-unknown-linux-musl.tar.gz" -o /tmp/fd.tar.gz
tar xz -f /tmp/fd.tar.gz -C /tmp
mv /tmp/fd-v10.2.0-x86_64-unknown-linux-musl/fd /usr/bin/fd
chmod +x /usr/bin/fd
rm -rf /tmp/fd*

echo ">> Native Installation Complete."
