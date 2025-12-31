#!/bin/bash
echo "🐺 Forging 'Creator' Container..."
distrobox create -n creator -i registry.fedoraproject.org/fedora:latest -Y
echo "Installing Multimedia Tools..."
distrobox enter creator -- sudo dnf install -y obs-studio kdenlive audacity
echo "Creator Pack Ready."
