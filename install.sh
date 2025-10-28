#!/usr/bin/env bash
set -e

REPO_URL="https://raw.githubusercontent.com/jaybabak/whatdidido/main"
INSTALL_DIR="$HOME/.local/bin"
SCRIPT_NAME="whatdidido"

echo "📦 Installing $SCRIPT_NAME..."
mkdir -p "$INSTALL_DIR"

# The actual URL we will fetch
SCRIPT_URL="$REPO_URL/whatdidido.sh"

# Log for debugging
echo "🔍 Attempting to download script from URL:"
echo "$SCRIPT_URL"

# Test the URL first
HTTP_STATUS=$(curl -o /dev/null -s -w "%{http_code}" "$SCRIPT_URL")
echo "🌐 HTTP status code: $HTTP_STATUS"

if [ "$HTTP_STATUS" -ne 200 ]; then
  echo "❌ ERROR: Script URL returned $HTTP_STATUS. Cannot continue installation."
  exit 1
fi

# Download the script
curl -fsSL "$SCRIPT_URL" -o "$INSTALL_DIR/$SCRIPT_NAME"
chmod +x "$INSTALL_DIR/$SCRIPT_NAME"

# Auto-detect shell config file
SHELL_RC=""

if [ -n "$ZSH_VERSION" ]; then
    SHELL_RC="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ]; then
    SHELL_RC="$HOME/.bashrc"
fi

# Fallback: if file doesn't exist, create it
if [ -z "$SHELL_RC" ] || [ ! -f "$SHELL_RC" ]; then
    SHELL_RC="$HOME/.zshrc"
    touch "$SHELL_RC"
fi

# Add INSTALL_DIR to PATH if missing
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    if ! grep -q "$INSTALL_DIR" "$SHELL_RC"; then
        echo "export PATH=\"\$HOME/.local/bin:\$PATH\"" >> "$SHELL_RC"
        echo "✅ Added $INSTALL_DIR to PATH in $SHELL_RC"
    fi
fi

# Correct log message showing the actual shell RC used
echo "👉 Run 'source $SHELL_RC' or open a new terminal to use '$SCRIPT_NAME'"
echo "🎉 Installed! Try running: $SCRIPT_NAME"
