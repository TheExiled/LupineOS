#!/bin/bash
echo "🐺 Applying 'Default COSMIC' Layout..."
# In the future, this will run: cosmic-settings set-layout default
# For now, we assume defaults are present.
dconf reset -f /org/gnome/
echo "Layout applied."
