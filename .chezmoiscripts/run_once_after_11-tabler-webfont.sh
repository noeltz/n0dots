#!/usr/bin/env bash
set -e

FONT_DIR="$HOME/.local/share/fonts/tabler-icons"
FONT_NAME="noctalia-tabler-icons.ttf"
URL="https://github.com/noctalia-dev/noctalia-shell/raw/refs/heads/main/Assets/Fonts/tabler/noctalia-tabler-icons.ttf"

mkdir -p "$FONT_DIR"
curl -sL -o "$FONT_DIR/$FONT_NAME" "$URL"
fc-cache -fv "$FONT_DIR" > /dev/null

if fc-list | grep -qi tabler; then
    echo "Installed: $FONT_DIR/$FONT_NAME"
    echo "Use in CSS: font-family: \"$(fc-query "$FONT_DIR/$FONT_NAME" | grep 'family:' | head -1 | cut -d'"' -f2)\";"
else
    echo "Error: Font not detected" >&2
    exit 1
fi
