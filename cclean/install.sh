#!/usr/bin/env bash
# Installs cclean to ~/.local/bin/cclean and registers the skill with Claude Code

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="$HOME/.local/bin/cclean"
SKILL_DEST="$HOME/.claude/skills/cclean"

mkdir -p "$HOME/.local/bin"
cp "$SCRIPT_DIR/cclean.py" "$DEST"
chmod +x "$DEST"

echo "cclean installed to $DEST"

mkdir -p "$SKILL_DEST"
cp "$SCRIPT_DIR/SKILL.md" "$SKILL_DEST/SKILL.md"

echo "cclean skill registered at $SKILL_DEST"

if ! echo "$PATH" | tr ':' '\n' | grep -qx "$HOME/.local/bin"; then
    echo ""
    echo "WARNING: ~/.local/bin is not in your PATH."
    echo "Add this to your ~/.zshrc or ~/.bashrc:"
    echo ""
    echo '  export PATH="$HOME/.local/bin:$PATH"'
    echo ""
    echo "Then run: source ~/.zshrc"
fi
