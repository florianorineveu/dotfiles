# Aliases shell - Honestly, what would we be without them?
#
# Copyright (c) 2026 Florian "Ori" Neveu
# SPDX-License-Identifier: WTFPL

[[ -f "$DOTFILES/lib/os.sh" ]] && source "$DOTFILES/lib/os.sh"

# ------------------------------------------------------------------
# Navigation
# ------------------------------------------------------------------
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias dotdir='cd $DOTFILES'

# ------------------------------------------------------------------
# Listing - Powered by eza
# ------------------------------------------------------------------
if command -v eza &>/dev/null; then
    alias ls='eza --group-directories-first'
    alias l='eza -l --group-directories-first --git'
    alias ll='eza -la --group-directories-first --git'
    alias lt='eza --tree --level=2'
    alias lta='eza -a --tree --level=2'
    alias ltt='eza --tree --level=3'
    alias ltta='eza -a --tree --level=3'
else
    alias ls='ls --color=auto --group-directories-first'
    alias l='ls -lh --group-directories-first'
    alias ll='ls -lAh --group-directories-first'
fi

# ------------------------------------------------------------------
# Cat (bat) - A cat with wings. Did Schrödinger have one?
# ------------------------------------------------------------------
if command -v bat &>/dev/null; then
    alias cat='bat'
fi

# ------------------------------------------------------------------
# Git (gud, lol)
# ------------------------------------------------------------------
alias g='git'
alias got='git'
alias gut='git'

alias gb='git branch'
alias gbd='git branch -D'
alias gcb='git checkout -b'

alias gd='git diff'
alias gdi='git diff --ignore-space-change'

alias gs='git status -sb'

alias ga='git add -A'
alias gc='git commit -v'

alias gp='git push'
alias gpo='git push origin'
alias gpom='git push origin main'
alias gpomm='git push origin master'
alias gl='git pull'
alias gfp='git fetch --all --prune --verbose'

alias gnuke='git reset --hard HEAD'

alias glog='git log --graph --pretty=format:"%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit --date=relative'

# ------------------------------------------------------------------
# Other
# ------------------------------------------------------------------
alias cl='clear'
alias mkdir='mkdir -p'
alias mk='mkdir'
alias e='nobrainextract'
alias fuck='fuck -y'
alias FUCK='fuck' # Monday morning

# Symfony
alias sf='symfony'
alias sfc='symfony console'

# WSL
if is_wsl; then
    alias o='explorer.exe'
    alias open='explorer.exe'
fi

# Linux/macOS
if is_macos || is_debian_based || is_arch_based; then
    # I don't want to have the machines against me when they rise up, sorry humanity.
    alias please='sudo'
fi
