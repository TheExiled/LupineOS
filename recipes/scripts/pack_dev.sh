#!/bin/bash
echo "🐺 Forging 'Dev' Container..."
distrobox create -n dev -i registry.fedoraproject.org/fedora:latest -Y
echo "Installing Dev Tools..."
distrobox enter dev -- sudo dnf install -y git neovim gcc make python3-pip nodejs
echo "Dev Pack Ready."
