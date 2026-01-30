# Main zsh configuration
#
# Copyright (c) 2026 Florian "Ori" Neveu
# SPDX-License-Identifier: WTFPL

[[ -f "$DOTFILES/lib/os.sh" ]] && source "$DOTFILES/lib/os.sh"

# ------------------------------------------------------------------
# History
# ------------------------------------------------------------------
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY

# ------------------------------------------------------------------
# zsh options
# ------------------------------------------------------------------
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt COMPLETE_IN_WORD
setopt EXTENDED_GLOB
setopt INTERACTIVE_COMMENTS
setopt NO_BEEP
setopt HIST_VERIFY

# ------------------------------------------------------------------
# Completion
# ------------------------------------------------------------------

# Custom completions
if [[ -d "$ZDOTDIR/completions" ]]; then
    FPATH="$ZDOTDIR/completions:$FPATH"
fi

# Homebrew completions
if [[ -d "/opt/homebrew/share/zsh/site-functions" ]]; then
    FPATH="/opt/homebrew/share/zsh/site-functions:$FPATH"
elif [[ -d "/usr/local/share/zsh/site-functions" ]]; then
    FPATH="/usr/local/share/zsh/site-functions:$FPATH"
fi

# Filter out broken symlinks from vendor-completions (e.g., Docker on WSL)
# This prevents compinit errors when completion files point to unmounted paths
if [[ -d "/usr/share/zsh/vendor-completions" ]]; then
    local comp_file
    for comp_file in /usr/share/zsh/vendor-completions/_*; do
        [[ -L "$comp_file" && ! -e "$comp_file" ]] && continue
    done
fi

autoload -Uz compinit
# Use -C to skip security check and speed up startup
# Regenerate dump once a day or if missing
local zcompdump="$XDG_CACHE_HOME/zsh/zcompdump"
if [[ -n "$zcompdump"(#qN.mh+24) || ! -f "$zcompdump" ]]; then
    compinit -d "$zcompdump"
else
    compinit -C -d "$zcompdump"
fi

# Case insensitive
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Menu selection
zstyle ':completion:*' menu select

# Colors in completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# ------------------------------------------------------------------
# Imports
# ------------------------------------------------------------------

# SSH agent (shared across sessions)
[[ -f "$ZDOTDIR/ssh-agent.zsh" ]] && source "$ZDOTDIR/ssh-agent.zsh"

# Plugins, powered by zinit
[[ -f "$ZDOTDIR/plugins.zsh" ]] && source "$ZDOTDIR/plugins.zsh"

# Exports
[[ -f "$ZDOTDIR/exports.zsh" ]] && source "$ZDOTDIR/exports.zsh"

# Aliases
[[ -f "$ZDOTDIR/aliases.zsh" ]] && source "$ZDOTDIR/aliases.zsh"

# Functions
[[ -f "$ZDOTDIR/functions.zsh" ]] && source "$ZDOTDIR/functions.zsh"

# Keybindings
[[ -f "$ZDOTDIR/keybindings.zsh" ]] && source "$ZDOTDIR/keybindings.zsh"

# Right prompt (language versions)
[[ -f "$ZDOTDIR/rprompt.zsh" ]] && source "$ZDOTDIR/rprompt.zsh"

# OS-specific configuration
os_config="$DOTFILES/os/$(detect_os)/config.zsh"
[[ -f "$os_config" ]] && source "$os_config"

# Local configuration
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

# ------------------------------------------------------------------
# Tools initialization (Let the Magic Begin!)
# ------------------------------------------------------------------

# Zoxide
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh)"
fi

# fzf
if [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]]; then
    source /usr/share/doc/fzf/examples/key-bindings.zsh
elif [[ -f /usr/share/fzf/key-bindings.zsh ]]; then
    source /usr/share/fzf/key-bindings.zsh
elif [[ -f ~/.fzf.zsh ]]; then
    source ~/.fzf.zsh
fi

# thefuck
if command -v thefuck &>/dev/null; then
    export THEFUCK_REQUIRE_CONFIRMATION=false  # -y par défaut
    eval "$(thefuck --alias)"
    alias FUCK='fuck'  # Monday morning
fi
