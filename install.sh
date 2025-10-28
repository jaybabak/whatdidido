#!/usr/bin/env bash

# Exit on error, but handle errors gracefully where needed
set -e

# Configuration
REPO_URL="https://raw.githubusercontent.com/jaybabak/whatdidido/main"
INSTALL_DIR="$HOME/.local/bin"
SCRIPT_NAME="whatdidido"
SCRIPT_URL="$REPO_URL/whatdidido.sh"

echo "📦 Installing $SCRIPT_NAME..."

# Create installation directory
mkdir -p "$INSTALL_DIR"

# Log the download URL
echo "🔍 Attempting to download script from:"
echo "   $SCRIPT_URL"

# Test URL accessibility
echo -n "🌐 Checking URL accessibility... "
HTTP_STATUS=$(curl -o /dev/null -s -w "%{http_code}" "$SCRIPT_URL")
echo "HTTP $HTTP_STATUS"

if [ "$HTTP_STATUS" -ne 200 ]; then
    echo "❌ ERROR: Script URL returned HTTP $HTTP_STATUS. Cannot continue installation."
    echo "   Please verify the repository and file exist at the URL above."
    exit 1
fi

# Download the script
echo "⬇️  Downloading script..."
if ! curl -fsSL "$SCRIPT_URL" -o "$INSTALL_DIR/$SCRIPT_NAME"; then
    echo "❌ ERROR: Failed to download script."
    exit 1
fi

# Make executable
chmod +x "$INSTALL_DIR/$SCRIPT_NAME"
echo "✅ Script installed to $INSTALL_DIR/$SCRIPT_NAME"

# Detect the appropriate shell configuration file
# Check $SHELL first (more reliable than checking version variables in install script)
SHELL_RC=""
SHELL_NAME=""

if [ -n "$SHELL" ]; then
    case "$SHELL" in
        */zsh)
            SHELL_RC="$HOME/.zshrc"
            SHELL_NAME="zsh"
            ;;
        */bash)
            # Check for .bash_profile on macOS, .bashrc on Linux
            if [[ "$OSTYPE" == "darwin"* ]] && [ -f "$HOME/.bash_profile" ]; then
                SHELL_RC="$HOME/.bash_profile"
            else
                SHELL_RC="$HOME/.bashrc"
            fi
            SHELL_NAME="bash"
            ;;
        */fish)
            SHELL_RC="$HOME/.config/fish/config.fish"
            SHELL_NAME="fish"
            ;;
        *)
            SHELL_RC="$HOME/.profile"
            SHELL_NAME="unknown"
            ;;
    esac
else
    # Fallback if $SHELL is not set
    SHELL_RC="$HOME/.profile"
    SHELL_NAME="unknown"
fi

echo "🐚 Detected shell: $SHELL_NAME"
echo "📝 Using config file: $SHELL_RC"

# Create shell config file if it doesn't exist
if [ ! -f "$SHELL_RC" ]; then
    touch "$SHELL_RC"
    echo "   Created $SHELL_RC"
fi

# Check if PATH already contains INSTALL_DIR
PATH_ENTRY="export PATH=\"\$HOME/.local/bin:\$PATH\""

if grep -q "\.local/bin" "$SHELL_RC" 2>/dev/null; then
    echo "ℹ️  PATH already configured in $SHELL_RC"
else
    # Add to PATH
    echo "" >> "$SHELL_RC"  # Add blank line for readability
    echo "# Added by $SCRIPT_NAME installer" >> "$SHELL_RC"
    echo "$PATH_ENTRY" >> "$SHELL_RC"
    echo "✅ Added $INSTALL_DIR to PATH in $SHELL_RC"
fi

# Final instructions
echo ""
echo "🎉 Installation complete!"
echo ""
echo "To start using $SCRIPT_NAME, either:"
echo "  1. Run: source $SHELL_RC"
echo "  2. Open a new terminal window"
echo ""
echo "Then try: $SCRIPT_NAME"
