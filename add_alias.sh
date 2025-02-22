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
    ALIAS_COMMAND="abbr"
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
while IFS='=' read -r name value; do
  # Skip empty lines
  [ -z "$name" ] && continue

  # Check for existing alias
  if [[ "$SHELL_NAME" == "fish" ]]; then
    existing_alias=$(abbr -a | grep "^$name\s" || true)
  else
    existing_alias=$(alias | grep "^$name=" || true)
  fi

  # Add only if alias doesn't exist
  if [ -z "$existing_alias" ]; then
    echo "$ALIAS_COMMAND $line" >> "$CONFIG_FILE"
  else
    echo "Alias '$name' already exists. Skipping."
  fi
done < "$ALIASES_FILE"

echo "Registered aliases in: $CONFIG_FILE"

# Reload config file
case "$SHELL_NAME" in
  bash | zsh)
    source "$CONFIG_FILE"
    ;;
  fish)
    source "$CONFIG_FILE"
    fish_update_completions
    ;;
esac

echo "Config file reloaded."

exit 0
