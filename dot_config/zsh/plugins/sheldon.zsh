#######################################
# SHELDON (PLUGIN MANAGER)
#######################################
export ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/oh-my-zsh"
mkdir -p "$ZSH_CACHE_DIR/completions"

eval "$(sheldon source)"
