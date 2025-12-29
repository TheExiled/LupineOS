#!/bin/bash
set -e

# --- Configuration ---
STATE_FILE="$HOME/.lupine_state"
COSMIC_REF="fedora:fedora/43/x86_64/cosmic-atomic"
TRIGGER_FILE="$HOME/.config/autostart/lupine-setup.desktop"
REPO_DIR="$HOME/lupineos"

# --- Visual Header ---
echo -e "\033[0;34m"
echo "=================================================="
echo "   🐺 LUPINEOS AUTOMATED INSTALLER   "
echo "=================================================="
echo -e "\033[0m"

# --- STAGE 1: THE REBASE (Silverblue -> Cosmic) ---
if [ ! -f "$STATE_FILE" ]; then
    echo ">> [STAGE 1/3] Preparing Environment..."
    echo ">> Current System: $(rpm-ostree status -b | head -n 1)"
    
    # Set flag for next boot
    echo "stage2" > "$STATE_FILE"

    echo ">> Downloading Cosmic Desktop Image..."
    echo ">> (This downloads the entire OS. Please wait.)"
    
    # We use '&&' to ensure we only reboot if the download succeeds
    rpm-ostree rebase "$COSMIC_REF" && {
        echo ">> ✅ Download Complete. System will reboot in 10 seconds..."
        sleep 10
        systemctl reboot
    }
    exit 0
fi

# Read State
CURRENT_STATE=$(cat "$STATE_FILE")

# --- STAGE 2: THE TOOLS (RPM Layering) ---
if [ "$CURRENT_STATE" == "stage2" ]; then
    echo ">> [STAGE 2/3] Welcome to Cosmic! Installing Core Tools..."
    
    # Update state for next boot
    echo "stage3" > "$STATE_FILE"

    echo ">> Installing: Helix, Zsh, Distrobox, Taskwarrior..."
    # We use --allow-inactive to prevent errors if repos changed during rebase
    rpm-ostree install -y --allow-inactive \
        git zsh util-linux-user starship stow \
        helix neovim eza ripgrep bat zoxide \
        yazi fzf fd-find tldr fastfetch \
        distrobox task && {
            echo ">> ✅ Tools Installed. Final Reboot initiating..."
            sleep 5
            systemctl reboot
        }
    exit 0
fi

# --- STAGE 3: THE FINISH (Flatpaks & Cleanup) ---
if [ "$CURRENT_STATE" == "stage3" ]; then
    echo ">> [STAGE 3/3] Final Polish..."

    echo ">> Installing Apps (Steam, Discord, etc)..."
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    flatpak install -y flathub \
        com.valvesoftware.Steam \
        com.heroicgameslauncher.hgl \
        net.lutris.Lutris \
        net.davidotek.pupgui2 \
        dev.vencord.Vesktop \
        com.github.tchx84.Flatseal \
        io.github.flattool.Warehouse \
        io.missioncenter.MissionCenter

    echo ">> Applying Configurations..."
    # Copy from the internal image location to your home folder
    cp -r /etc/skel/.config/* ~/.config/ 2>/dev/null || true
    
    # Set Zsh Default
    if [ "$SHELL" != "/usr/bin/zsh" ]; then
        echo ">> Setting Zsh as default shell..."
        sudo lchsh $USER /usr/bin/zsh
    fi

    # --- SELF DESTRUCT SEQUENCE ---
    echo ">> 🧹 Cleanup..."
    rm -f "$STATE_FILE"
    rm -f "$TRIGGER_FILE"  # <--- This stops the script from running again

    echo "=================================================="
    echo "   ✅ LUPINEOS INSTALLATION COMPLETE   "
    echo "=================================================="
    echo "   Press ENTER to close this window and start your journey."
    read
    exit 0
fi
