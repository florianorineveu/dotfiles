# Environment variables
#
# Copyright (c) 2026 Florian "Ori" Neveu
# SPDX-License-Identifier: WTFPL

[[ -f "$DOTFILES/lib/utils.sh" ]] && source "$DOTFILES/lib/utils.sh"

# ------------------------------------------------------------------
# Editor
# ------------------------------------------------------------------
export EDITOR="nvim"
export VISUAL="nvim"

# ------------------------------------------------------------------
# Directories
# ------------------------------------------------------------------
export DEVFOLDER="$HOME/Code"

# ------------------------------------------------------------------
# Path
# ------------------------------------------------------------------

# Dotfiles bin
export PATH="$DOTFILES/bin:$PATH"

# Local bin
if [[ -d "$HOME/.local/bin" ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# Volta
if [[ -d "$HOME/.volta/bin" ]]; then
    export VOLTA_HOME="$HOME/.volta"
    export PATH="$VOLTA_HOME/bin:$PATH"
fi

# ------------------------------------------------------------------
# XDG Base Directory
# ------------------------------------------------------------------
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# ------------------------------------------------------------------
# CLI tools
# ------------------------------------------------------------------

# GPG for commit signing
export GPG_TTY=$(tty)

# fzf options
export FZF_DEFAULT_OPTS="
  --height=40%
  --layout=reverse
  --border
  --inline-info
  --color=dark
  --color=fg:-1,bg:-1,hl:#5fff87,fg+:-1,bg+:-1,hl+:#ffaf5f
  --color=info:#af87ff,prompt:#5fff87,pointer:#ff87d7,marker:#ff87d7,spinner:#ff87d7
"

# Use fd for fzf if available
if command_exists fd; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

# bat theme
export BAT_THEME="Catppuccin Mocha"

# Less options
export LESS='-R -F -X'

# Use bat for man pages
if command_exists bat; then
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi
