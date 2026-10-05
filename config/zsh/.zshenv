# zsh bootstrap file
#
# Copyright (c) 2026 Florian "Ori" Neveu
# SPDX-License-Identifier: WTFPL

if [[ -L ~/.zshenv ]]; then
    # ${(%):-%x} = chemin de ce fichier tel que zsh l'a ouvert, et :A le résout
    # en suivant TOUS les liens symboliques (un seul `readlink` ne suit que le
    # premier maillon : avec Home Manager, ~/.zshenv pointe d'abord vers /nix/store).
    # :h:h:h remonte de config/zsh/.zshenv jusqu'à la racine du dépôt.
    export DOTFILES="${${(%):-%x}:A:h:h:h}"
else
    export DOTFILES="$HOME/.dotfiles"
fi

export ZDOTDIR="$DOTFILES/config/zsh"
export XDG_CACHE_HOME="$HOME/.cache"
