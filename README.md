# 🐺 LupineOS (WolfPack v0.1)

```text
██╗     ██╗   ██╗██████╗ ██╗███╗   ██╗███████╗ ██████╗ ███████╗
██║     ██║   ██║██╔══██╗██║████╗  ██║██╔════╝██╔═══██╗██╔════╝
██║     ██║   ██║██████╔╝██║██╔██╗ ██║█████╗  ██║   ██║███████╗
██║     ██║   ██║██╔═══╝ ██║██║╚██╗██║██╔══╝  ██║   ██║╚════██║
███████╗╚██████╔╝██║     ██║██║ ╚████║███████╗╚██████╔╝███████║
╚══════╝ ╚═════╝ ╚═╝     ╚═╝╚═╝  ╚═══╝╚══════╝ ╚═════╝ ╚══════╝
```

**Version:** 0.1.0 (Alpha)
**Codename:** WolfPack
**Host OS:** Fedora Atomic (COSMIC Desktop)
**Hardware Target:** Dell XPS 9570 (i7-8750H / 32GB RAM / GTX 1050 Ti)

______________________________________________________________________

🚀 Installation (The "Autopilot" Method)

1. **Download ISO:** Grab the latest `lupineos-installer.iso` from the **Releases** or **Actions** tab.
2. **Flash:** Burn it to a USB stick using Fedora Media Writer or BalenaEtcher.
3. **Install:** Boot the USB and install Fedora normally.
   - *Note: The installer may look like standard Fedora 41, but it will pull your custom OS.*
4. **First Boot:**
   - Log in.
   - **Do NOT touch anything.**
   - A terminal window ("LupineOS Setup") will open automatically.
   - It will reboot your system twice to apply the Cosmic desktop and install all tools.
   - When it says "LUPINEOS COMPLETE", you are ready to hunt.

______________________________________________________________________

## 🛠 Manual Installation (Legacy)

*Note: The legacy bootstrap script is available on the `legacy-bootstrap` branch.*

______________________________________________________________________

## 🛠 Manual Installation (Legacy)

*Note: The legacy bootstrap script is available on the `legacy-bootstrap` branch.*

If you are already on Fedora Atomic and just want the dotfiles:

1. **Clone Repo:** `git clone https://github.com/TheExiled/LupineOS.git ~/LupineOS`
2. **Run Script:** `cd ~/LupineOS && ./install.sh`


## 1. Core Philosophy

**"Many parts, one instinct."**
LupineOS follows a strict **Atomic/Container** architecture to separate concerns while functioning as a unified whole.

1. **Immutable Host:** The base OS is read-only.
1. **The Pack (Containers):** Distinct, specialized environments (`dev`, `admin`, `sec`) that hunt together.
1. **Unified Senses:** All environments share the same shell (`zsh`), prompt (`starship`), and editor (`helix`) config via the shared `/home` directory.

______________________________________________________________________

## 2. The Host Environment

These tools are installed on the host to ensure fast access to the filesystem and hardware.

### 2.1. Native Binaries

Installed manually to `~/.local/bin` to bypass `rpm-ostree` layering.

- **`eza`**: Modern `ls` replacement (Rust).
- **`ripgrep` (`rg`)**: Recursive search respecting `.gitignore` (Rust).
- **`bat`**: `cat` with syntax highlighting (Rust).
- **`zoxide`**: Smart directory jumping (Rust).

### 2.2. Gaming & GUI Stack (Flatpaks)

Gaming runs isolated from the dev environment using Flatpaks.

- **Launchers:** Steam, Heroic (Epic/GOG), Lutris.
- **Utils:** ProtonUp-Qt, MangoHud, GOverlay.
- **Communication:** Vesktop (Discord with Wayland screen share).
- **Management:** Flatseal (Permissions), Warehouse (Cleanup).

______________________________________________________________________

## 3. The Pack (Container Ecosystem)

We maintain three distinct environments managed via Distrobox.

### 📦 Container A: `dev` (The Alpha)

- **Base:** Fedora
- **Purpose:** Rust Development, Python Scripting, AI Interaction.
- **Key Tools:**
  - **Languages:** Rust (via `rustup`), Python 3.
  - **Editors:** Helix (`hx`), Neovim.
  - **Git:** `lazygit` (TUI), `gh` (GitHub CLI).

### 📦 Container B: `admin` (The Beta)

- **Base:** Ubuntu
- **Purpose:** DevOps, Cloud Infrastructure, Server Management.
- **Key Tools:**
  - **IaC:** Ansible, Terraform.
  - **Cloud:** AWS CLI.
  - **Network:** `dig`, `whois`, `traceroute`.

### 📦 Container C: `sec` (The Omega)

- **Base:** Kali Linux Rolling
- **Purpose:** Cybersecurity, Penetration Testing.
- **Key Tools:**
  - **Recon:** Nmap, Masscan.
  - **Web:** Burp Suite, SQLMap.
  - **Attack:** Metasploit, Hydra.

### 📦 Container D: \`data\` (The Lab)

- **Base:** Fedora
- **Purpose:** Data Science, Database Administration, Local LLM Testing.
- **Key Tools:** JupyterLab, Pandas, NumPy, PostgreSQL Client, SQLite.

### 📦 Container E: \`arch\` (The Sandbox)

- **Base:** Arch Linux
- **Purpose:** Access to the AUR (Arch User Repository) and bleeding-edge packages.
- **Key Tools:** `yay` (AUR Helper), `pacman`.
- **Note:** Built via `setup_sandbox.sh` to auto-compile `yay`.---

## 4. Automation & Structure

- `configs/`: Shared dotfiles (Zellij, Helix, Starship).
- `assets/`: Branding and Wallpapers.
- `scripts/`:
  - **`setup_admin.sh`**: Builds the Ubuntu Sysadmin container.
  - **`setup_sec.sh`**: Builds the Kali Security container.
  - **`install_rust_tools.sh`**: Compiles and exports Rust replacements.
