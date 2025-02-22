#!/bin/bash

# Get aliases file path from argument
ALIASES_FILE="$1"

# Detect shell environment
SHELL_NAME=$(basename "$SHELL")

case "$SHELL_NAME" in
  bash)
    CONFIG_FILE="$HOME/.bashrc"
    ALIAS_COMMAND="alias"
    ;;
  zsh)
    CONFIG_FILE="$HOME/.zshrc"
    ALIAS_COMMAND="alias"
    ;;
  fish)
    CONFIG_FILE="$HOME/.config/fish/config.fish"
    ALIAS_COMMAND="abbr -a"
    ;;
  *)
    echo "Unsupported shell environment: $SHELL_NAME"
    exit 1
    ;;
esac

# Check if config file exists
if [ ! -f "$CONFIG_FILE" ]; then
  touch "$CONFIG_FILE"
  echo "Created config file: $CONFIG_FILE"
fi

# Write aliases to file
echo "" >> "$CONFIG_FILE"
echo "# Additional aliases" >> "$CONFIG_FILE"

# Read aliases list and write to config file
while IFS=',' read -r name value; do
  # Skip empty lines
  [ -z "$name" ] && continue

  echo "Processing: $name = $value"

  if [ "$SHELL_NAME" = "fish" ]; then
    existing_alias=$(grep "^abbr -a $name " "$CONFIG_FILE" 2>/dev/null || true)
  else
    existing_alias=$(grep "^alias $name=" "$CONFIG_FILE" 2>/dev/null || true)
  fi

  if [ -z "$existing_alias" ]; then
    if [ "$SHELL_NAME" = "fish" ]; then
      echo "$ALIAS_COMMAND $name '$value'" >> "$CONFIG_FILE"
    else
      echo "$ALIAS_COMMAND $name='$value'" >> "$CONFIG_FILE"
    fi
    echo "Added alias: $name"
  else
    echo "Alias '$name' already exists. Skipping."
  fi
done < "$ALIASES_FILE"

echo "Registered aliases in: $CONFIG_FILE"

# Reload config file
case "$SHELL_NAME" in
  bash)
    exec bash -l
    ;;
  zsh)
    exec zsh -l
    ;;
  fish)
    exec fish -l
    ;;
esac

echo "Config file reloaded."

exit 0
