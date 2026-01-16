# zsh bootstrap file
#
# Copyright (c) 2026 Florian "Ori" Neveu
# SPDX-License-Identifier: WTFPL

if [[ -L ~/.zshenv ]]; then
    DOTFILES_RESOLVED="$(readlink ~/.zshenv)"
    export DOTFILES="$(cd "$(dirname "$DOTFILES_RESOLVED")/../.." && pwd -P)"
else
    export DOTFILES="$HOME/.dotfiles"
fi

export ZDOTDIR="$DOTFILES/config/zsh"
export XDG_CACHE_HOME="$HOME/.cache"
