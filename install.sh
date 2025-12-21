#!/bin/bash
# 🐺 LupineOS Master Installer
# Version: 1.0 (WolfPack)
# Purpose: Single-command setup for configs, assets, and containers.

set -e # Exit immediately if a command exits with a non-zero status

# --- Variables ---
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIGS_DIR="$REPO_ROOT/configs"
SCRIPTS_DIR="$REPO_ROOT/scripts"
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%s)"

# --- Visuals ---
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}
██╗     ██╗   ██╗██████╗ ██╗███╗   ██╗███████╗ ██████╗ ███████╗
██║     ██║   ██║██╔══██╗██║████╗  ██║██╔════╝██╔═══██╗██╔════╝
██║     ██║   ██║██████╔╝██║██╔██╗ ██║█████╗  ██║   ██║███████╗
██║     ██║   ██║██╔═══╝ ██║██║╚██╗██║██╔══╝  ██║   ██║╚════██║
███████╗╚██████╔╝██║     ██║██║ ╚████║███████╗╚██████╔╝███████║
╚══════╝ ╚═════╝ ╚═╝     ╚═╝╚═╝  ╚═══╝╚══════╝ ╚═════╝ ╚══════╝
${NC}"
echo "Welcome to the LupineOS Installer."
echo "Source: $REPO_ROOT"
echo "---------------------------------------------------"

# --- Function: Link Configs (Stow) ---
link_configs() {
    echo -e "\n${YELLOW}[1/4] Linking Configurations...${NC}"
    
    # Check if configs directory exists
    if [ ! -d "$CONFIGS_DIR" ]; then
        echo "❌ Error: Configs directory not found at $CONFIGS_DIR"
        return
    fi

    # Determine Method: Host vs Container
    if command -v stow &> /dev/null; then
        METHOD="host"
        echo "   -> Using Host 'stow'..."
    elif command -v distrobox &> /dev/null; then
        METHOD="container"
        echo "   -> Host 'stow' missing. Delegating to 'admin' container..."
        # Ensure admin exists
        if ! distrobox list | grep -q "admin"; then
            echo "   ⚠️  'admin' container not found. Building it now..."
            $SCRIPTS_DIR/setup_admin.sh
        fi
        # Ensure stow is installed in admin
        distrobox enter admin -- sudo apt-get install -y stow &> /dev/null
    else
        echo "❌ Error: Neither 'stow' nor 'distrobox' found."
        exit 1
    fi

    # Execute Stow
    cd "$CONFIGS_DIR"
    for app in */; do
        app_name=$(basename "$app")
        echo "   -> Stowing: $app_name"
        
        # Clean up existing default files if they block stow (Optional safety)
        # rm -rf "$HOME/.config/$app_name" 

        if [ "$METHOD" == "host" ]; then
            stow -R -t "$HOME" "$app_name"
        else
            # Run inside container (Paths are shared via $HOME)
            distrobox enter admin -- sh -c "cd $CONFIGS_DIR && stow -R -t $HOME $app_name"
        fi
    done
    echo -e "${GREEN}✅ Configs Linked.${NC}"
}

# --- Function: Install Fonts ---
install_fonts() {
    echo -e "\n${YELLOW}[2/4] Installing Nerd Fonts...${NC}"
    if [ -f "$SCRIPTS_DIR/install_fonts.sh" ]; then
        $SCRIPTS_DIR/install_fonts.sh
    else
        echo "   ⚠️  Font script missing."
    fi
}

# --- Function: Apply Branding ---
apply_branding() {
    echo -e "\n${YELLOW}[3/4] Applying Branding (Wallpapers)...${NC}"
    if [ -f "$SCRIPTS_DIR/setup_branding.sh" ]; then
        $SCRIPTS_DIR/setup_branding.sh
    else
        echo "   ⚠️  Branding script missing."
    fi
}

# --- Function: Build Containers ---
setup_containers() {
    echo -e "\n${YELLOW}[4/4] Container Ecosystem (The Pack)${NC}"
    echo "Do you want to build/update the containers? (y/n)"
    read -r -p "Select: " response
    if [[ "$response" =~ ^[yY]$ ]]; then
        echo "   🐺 unleashing the pack..."
        
        # Admin
        [ -f "$SCRIPTS_DIR/setup_admin.sh" ] && $SCRIPTS_DIR/setup_admin.sh
        
        # Security
        [ -f "$SCRIPTS_DIR/setup_sec.sh" ] && $SCRIPTS_DIR/setup_sec.sh
        
        # Data/Lab
        [ -f "$SCRIPTS_DIR/setup_data.sh" ] && $SCRIPTS_DIR/setup_data.sh
        
        # Rust Tools
        [ -f "$SCRIPTS_DIR/install_rust_tools.sh" ] && $SCRIPTS_DIR/install_rust_tools.sh
        
        echo -e "${GREEN}✅ All containers ready.${NC}"
    else
        echo "   -> Skipping container setup."
    fi
}

# --- Execution ---
link_configs
install_fonts
apply_branding
setup_containers

echo -e "\n${GREEN}🎉 LupineOS Installation Complete!${NC}"
echo "   Please reboot your system to finalize font and UI changes."
