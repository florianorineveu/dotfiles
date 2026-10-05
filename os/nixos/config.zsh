# Aliases shell - NixOS
#
# Copyright (c) 2026 Florian "Ori" Neveu
# SPDX-License-Identifier: WTFPL

# ------------------------------------------------------------------
# Configuration système (dépôt ~/nixos-config)
# Rappel : les flakes ignorent les fichiers que git ne connaît pas (git add !)
# ------------------------------------------------------------------
alias nrs='sudo nixos-rebuild switch --flake ~/nixos-config#$(hostname)'
alias nrt='sudo nixos-rebuild test --flake ~/nixos-config#$(hostname)'
alias nrb='sudo nixos-rebuild boot --flake ~/nixos-config#$(hostname)'
alias nfu='(cd ~/nixos-config && nix flake update)'

# ------------------------------------------------------------------
# Other
# ------------------------------------------------------------------
alias sys='sudo systemctl'
