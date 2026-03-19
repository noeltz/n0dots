#!/usr/bin/env bash

# ==============================================================================
# Tabler Icons Webfont Installer (User Local)
# Target: Arch Linux (No Sudo)
# ==============================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
FONT_DIR="$HOME/.local/share/fonts/tabler-icons"
CACHE_CMD="fc-cache"
DOWNLOAD_DIR=$(mktemp -d)

# Font Files to download from GitHub Master Branch
# Using raw.githubusercontent.com for direct download
BASE_URL="https://raw.githubusercontent.com/tabler/tabler-icons/master/packages/icons-font/fonts"
FILES=(
    "tabler-icons.ttf"
    "tabler-icons-filled.ttf"
    "tabler-icons-outline.ttf"
)

echo -e "${YELLOW}>>> Starting Tabler Icons Installation...${NC}"

# 1. Check dependencies
if ! command -v curl &> /dev/null; then
    echo -e "${RED}Error: 'curl' is not installed. Please install it to proceed.${NC}"
    exit 1
fi

if ! command -v fc-cache &> /dev/null; then
    echo -e "${RED}Error: 'fc-cache' (fontconfig) is not installed.${NC}"
    exit 1
fi

# 2. Create local font directory
echo -e ">>> Creating directory: ${FONT_DIR}"
mkdir -p "${FONT_DIR}"

# 3. Download Fonts
echo -e ">>> Downloading font files..."
cd "${DOWNLOAD_DIR}"

for file in "${FILES[@]}"; do
    echo -e "    Downloading ${file}..."
    if curl -sL -O "${BASE_URL}/${file}"; then
        if [ -f "${file}" ]; then
            echo -e "    ${GREEN}✓${NC} Downloaded ${file}"
        else
            echo -e "    ${RED}✗${NC} Failed to download ${file}"
        fi
    else
        echo -e "    ${RED}✗${NC} Connection error for ${file}"
    fi
done

# 4. Install Fonts
echo -e ">>> Installing fonts to user directory..."
cp -v *.ttf "${FONT_DIR}/"

# 5. Clean up temp directory
rm -rf "${DOWNLOAD_DIR}"

# 6. Update Font Cache
echo -e ">>> Updating font cache..."
if ${CACHE_CMD} -fv "${FONT_DIR}" > /dev/null; then
    echo -e "${GREEN}>>> Font cache updated successfully.${NC}"
else
    echo -e "${YELLOW}>>> Font cache update finished (warnings may be ignored).${NC}"
fi

# 7. Verification
echo -e "\n${GREEN}>>> Installation Complete!${NC}"
