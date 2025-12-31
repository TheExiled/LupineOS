#!/bin/bash
echo "🐺 Forging 'Gamer' Container..."
distrobox create -n gamer -i registry.fedoraproject.org/fedora:latest -Y
echo "Installing Gaming Tools (Steam, Lutris)..."
distrobox enter gamer -- sudo dnf install -y steam lutris gamemode mangohud
echo "Gamer Pack Ready."
