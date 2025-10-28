#!/usr/bin/env bash
set -e

REPO_URL="https://raw.githubusercontent.com/jaybabak/whatdidido/main"
INSTALL_DIR="$HOME/.local/bin"
SCRIPT_NAME="whatdidido"

echo "📦 Installing $SCRIPT_NAME..."

mkdir -p "$INSTALL_DIR"

# Download latest version
curl -fsSL "$REPO_URL/whatdidido.sh" -o "$INSTALL_DIR/$SCRIPT_NAME"
chmod +x "$INSTALL_DIR/$SCRIPT_NAME"

# Add to PATH if missing
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
  SHELL_RC="$HOME/.bashrc"
  [ -n "$ZSH_VERSION" ] && SHELL_RC="$HOME/.zshrc"

  if ! grep -q "$INSTALL_DIR" "$SHELL_RC"; then
    echo "export PATH=\"\$HOME/.local/bin:\$PATH\"" >> "$SHELL_RC"
    echo "✅ Added $INSTALL_DIR to PATH in $SHELL_RC"
  fi
  echo "👉 Run 'source $SHELL_RC' or open a new terminal to use '$SCRIPT_NAME'"
else
  echo "✅ $INSTALL_DIR is already in PATH."
fi

echo "🎉 Installed! Try running: $SCRIPT_NAME"
