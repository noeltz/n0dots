#######################################
# SHELDON (PLUGIN MANAGER)
#######################################
export ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/oh-my-zsh"
mkdir -p "$ZSH_CACHE_DIR/completions"

autoload -Uz compinit
compinit

eval "$(sheldon source)"
# Plugin-specific settings
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
