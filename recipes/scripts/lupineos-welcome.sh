#!/bin/bash
set -e

# Marker to prevent re-running
MARKER="$HOME/.config/lupineos/setup-complete"
LOG_FILE="$HOME/lupineos-bootstrap.log"

if [ -f "$MARKER" ]; then
    exit 0
fi

# Visuals
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# --- DEPRECATED: This logic is now handled by the 'lupineos-welcome' GUI app ---
# The GUI calls the individual scripts directly (e.g., setup_admin.sh)
# Keeping this file for manual debugging if needed, but it is no longer the primary entry point.
