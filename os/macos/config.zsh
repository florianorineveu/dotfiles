# Aliases shell - macOS
#
# Copyright (c) 2026 Florian "Ori" Neveu
# SPDX-License-Identifier: WTFPL

alias update='sudo softwareupdate -i -a; brew update; brew upgrade; brew cleanup; brew doctor;'
# ------------------------------------------------------------------
# Homebrew
# ------------------------------------------------------------------
if [[ -d "/opt/homebrew/bin" ]]; then
    export PATH="/opt/homebrew/bin:$PATH"
fi
