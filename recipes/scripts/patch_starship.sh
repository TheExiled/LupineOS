#!/bin/bash

CONFIG_FILE="$HOME/.config/starship.toml"

echo "🎨 Patching Starship Configuration..."

# 1. Backup existing config
cp "$CONFIG_FILE" "$CONFIG_FILE.bak"
echo "   Backup saved to $CONFIG_FILE.bak"

# 2. Define the Context Modules
# Check if we already patched it to prevent duplication
if grep -q "custom.dev_context" "$CONFIG_FILE"; then
    echo "   Config already patched, skipping append."
else
    # We use a heredoc to append the [custom] blocks to the end of the file
    cat <<EOF >> "$CONFIG_FILE"

# --- DISTROBOX CONTEXT BADGES ---

[custom.dev_context]
command = "echo '🚧 DEV'"
when = 'test "\$DISTROBOX_ENTER_NAME" = "dev"'
style = "bold #ffaf00"
format = "[\$output](\$style) "

[custom.sysadmin_context]
command = "echo '⚡ SYS'"
when = 'test "\$DISTROBOX_ENTER_NAME" = "admin"'
style = "bold blue"
format = "[\$output](\$style) "

[custom.sec_context]
command = "echo '💀 SEC'"
when = 'test "\$DISTROBOX_ENTER_NAME" = "sec"'
style = "bold red"
format = "[\$output](\$style) "
EOF
fi

# 3. Prepend the format string to the top of the file
# This ensures our new modules are actually rendered.
# We use a temporary file to construct the new config order.
echo 'format = "${custom.dev_context}${custom.sysadmin_context}${custom.sec_context}$all"' > temp_starship.toml
cat "$CONFIG_FILE" >> temp_starship.toml
mv temp_starship.toml "$CONFIG_FILE"

echo "✅ Starship patched! Open a new terminal to see the changes."
