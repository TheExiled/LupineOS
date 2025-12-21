#!/bin/bash
set -e

DOTFILES_DIR="$HOME/dotfiles"
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%s)"

echo "🔗 Initializing Dotfiles Strategy (GNU Stow)..."

# 1. Install Stow (Using the Admin container to avoid rebooting host)
# We can run stow from inside a container because it operates on /home (shared)
distrobox enter admin -- sudo apt-get update
distrobox enter admin -- sudo apt-get install -y stow

# 2. Create Directory Structure
mkdir -p "$DOTFILES_DIR"

# Function to move and stow a config
move_and_stow() {
    PKG_NAME=$1
    # Define Source and Destination
    # Example: ~/.config/zellij -> ~/dotfiles/zellij/.config/zellij
    SRC_PATH="$HOME/.config/$PKG_NAME"
    DEST_PARENT="$DOTFILES_DIR/$PKG_NAME/.config"
    DEST_PATH="$DEST_PARENT/$PKG_NAME"

    if [ -d "$SRC_PATH" ] || [ -f "$SRC_PATH" ]; then
        echo "   Processing $PKG_NAME..."
        
        # Create destination folder structure
        mkdir -p "$DEST_PARENT"
        
        # Move original config to dotfiles repo
        mv "$SRC_PATH" "$DEST_PARENT/"
        
        # Run Stow (from inside dotfiles dir, targeting Home)
        # We use 'distrobox enter admin' to run the stow command
        distrobox enter admin -- sh -c "cd $DOTFILES_DIR && stow -t $HOME $PKG_NAME"
        
        echo "   ✅ Stowed $PKG_NAME"
    else
        echo "   ⚠️ Config for $PKG_NAME not found, skipping."
    fi
}

# 3. Execute Move for Key Tools
echo "📦 Moving configurations to $DOTFILES_DIR..."

# Zellij
move_and_stow "zellij"

# Helix
move_and_stow "helix"

# Starship (File needs special handling since it might be a single file, not a folder)
# Usually starship.toml is in ~/.config/starship.toml
if [ -f "$HOME/.config/starship.toml" ]; then
    echo "   Processing starship..."
    mkdir -p "$DOTFILES_DIR/starship/.config"
    mv "$HOME/.config/starship.toml" "$DOTFILES_DIR/starship/.config/"
    distrobox enter admin -- sh -c "cd $DOTFILES_DIR && stow -t $HOME starship"
    echo "   ✅ Stowed starship"
fi

echo "🎉 Dotfiles setup complete!"
echo "   Your configs are now in $DOTFILES_DIR"
echo "   To share them: 'cd ~/dotfiles && git init && git push...'"
