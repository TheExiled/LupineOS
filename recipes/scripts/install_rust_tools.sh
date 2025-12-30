#!/bin/bash
set -e

echo "🦀 Installing Rust Rewrite Suite..."

# We run this INSIDE the 'dev' container because that is where cargo lives.
# We then EXPORT the binaries to the host.

distrobox enter dev -- sh -c '
    # 1. Update Cargo index
    echo "Updating Cargo..."
    cargo search ripgrep --limit 1 > /dev/null

    # 2. Install Tools
    # du-dust = dust (Disk Usage)
    # procs = procs (Process Viewer)
    # tealdeer = tldr (Man pages)
    # zoxide = z (Directory Jumper)
    # bat = bat (Cat replacement)
    
    echo "Compiling tools (this may take a moment)..."
    cargo install du-dust procs tealdeer zoxide bat antigravity gemini-cli

    # 3. Export to Host
    # This creates a symlink in ~/.local/bin on your Fedora Host
    echo "Exporting binaries to Host..."
    distrobox-export --bin $(which dust)
    distrobox-export --bin $(which procs)
    distrobox-export --bin $(which tldr)
    distrobox-export --bin $(which zoxide)
    distrobox-export --bin $(which bat)
    distrobox-export --bin $(which antigravity)
    distrobox-export --bin $(which gemini)
    
    # Initialize tldr cache
    tldr --update
'

echo "✅ Rust Tools Installed & Exported."
echo "   Try running 'dust' or 'tldr tar' in your host terminal."
