#!/usr/bin/env bash
set -euo pipefail

shopt -s nullglob globstar

readonly LIB_DIR="${CHEZMOI_SOURCE_DIR:-$(chezmoi source-path)}/.chezmoiscripts/lib"

# shellcheck source=/dev/null
source "$LIB_DIR/.lib-common.sh"

# --- CONFIGURATION ---
FONT_DIR="$HOME/.local/share/fonts"
ZIP_URLS=(
    https://github.com/noeltz/custom-maple-font/releases/latest/download/NFM_MapleMonoNormal-NF.zip
    https://github.com/noeltz/custom-maple-font/releases/latest/download/NFP_MapleMonoNormal-NF.zip
)
GITHUB_REPOS=(
    #noeltz/custom-maple-font
)
# ---------------------

print_box "Fonts"
log STEP "Installing Maple Mono NerdFonts..."

mkdir -p "$FONT_DIR"
TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT
cd "$TEMP_DIR"

ALL_ZIPS=("${ZIP_URLS[@]}")

for repo in "${GITHUB_REPOS[@]}"; do
    while IFS= read -r url; do
        [[ -n "$url" ]] && ALL_ZIPS+=("$url")
    done < <(curl -s "https://api.github.com/repos/${repo}/releases/latest" | jq -r '.assets[] | select(.name | endswith(".zip")) | .browser_download_url')
done

for url in "${ALL_ZIPS[@]}"; do
    [[ -z "$url" ]] && continue
    curl -L -s -O "$url"
    zip_file=$(basename "$url")
    unzip -q -o "$zip_file"
    find . -type f -iname "*.ttf" -exec cp {} "$FONT_DIR" \;
done

fc-cache -f
log INFO "Installed Fonts to $FONT_DIR"
