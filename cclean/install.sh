#!/usr/bin/env bash
# Installs cclean to ~/.local/bin/cclean

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="$HOME/.local/bin/cclean"

mkdir -p "$HOME/.local/bin"
cp "$SCRIPT_DIR/cclean.py" "$DEST"
chmod +x "$DEST"

echo "cclean installed to $DEST"

if ! echo "$PATH" | tr ':' '\n' | grep -qx "$HOME/.local/bin"; then
    echo ""
    echo "WARNING: ~/.local/bin is not in your PATH."
    echo "Add this to your ~/.zshrc or ~/.bashrc:"
    echo ""
    echo '  export PATH="$HOME/.local/bin:$PATH"'
    echo ""
    echo "Then run: source ~/.zshrc"
fi
