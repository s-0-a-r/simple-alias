#!/bin/bash

echo "[download script] start"

# URLs for downloading script and alias file
SCRIPT_URL="https://raw.githubusercontent.com/s-0-a-r/simple-alias/HEAD/add_alias.sh"
ALIAS_URL="https://raw.githubusercontent.com/s-0-a-r/simple-alias/HEAD/alias.txt"

# Installation paths
DOWNLOAD_DIR="$HOME/.local/bin"
SCRIPT_NAME="add_alias.sh"
ALIAS_FILE_NAME="alias.txt"
SCRIPT_PATH="$DOWNLOAD_DIR/$SCRIPT_NAME"
ALIAS_PATH="$DOWNLOAD_DIR/$ALIAS_FILE_NAME"

# Create installation directory if not exists
mkdir -p "$DOWNLOAD_DIR"

# Download script and alias list
curl -fsSL "$SCRIPT_URL" -o "$SCRIPT_PATH"
curl -fsSL "$ALIAS_URL" -o "$ALIAS_PATH"

# Make script executable
chmod +x "$SCRIPT_PATH"

echo "[download script] complete"
echo "[setup alias] start"

# Execute the downloaded script
"$SCRIPT_PATH" "$ALIAS_PATH"

echo "[setup alias] complete"
