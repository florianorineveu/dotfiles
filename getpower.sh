#!/usr/bin/env bash
#
# Copyright (c) 2026 Florian "Ori" Neveu
# SPDX-License-Identifier: WTFPL
#
# getpower.sh - Installation script of dotfiles
#
# Usage:
#   --profile=PROFILE   Installation profile (minimal, full)
#   --backup            Save current configuration before installation
#   --no-packages       Don't install packages, only symlinks
#   --dry-run           Displays what would be done without executing it
#   --rollback          Restore last backup
#   -h, --help          Display this help
#

set -euo pipefail

# ------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DOTFILES="$SCRIPT_DIR"

# Default profil and options
PROFILE="full"
DO_BACKUP=false
INSTALL_PACKAGES=true
DRY_RUN=false
DO_ROLLBACK=false

VALID_PROFILES="minimal full"

# ------------------------------------------------------------------
# Import libs
# ------------------------------------------------------------------
source "$DOTFILES/lib/utils.sh"
source "$DOTFILES/lib/os.sh"
source "$DOTFILES/lib/symlinks.sh"
source "$DOTFILES/lib/packages.sh"

# ------------------------------------------------------------------
# Help
# ------------------------------------------------------------------
show_help() {
    printf "${BOLD}Dotfiles Installer${RESET}\n\n"
    printf "${CYAN}Usage:${RESET}\n"
    printf "    ./getpower.sh [OPTIONS]\n\n"
    printf "${CYAN}Options:${RESET}\n"
    printf "    --profile=PROFILE   Profil d'installation:\n"
    printf "                        - ${GREEN}minimal${RESET}: git, zsh, starship\n"
    printf "                        - ${GREEN}full${RESET}: tous les outils [défaut]\n"
    printf "    --backup            Sauvegarde la config existante avant installation\n"
    printf "    --no-packages       N'installe pas les paquets, symlinks seulement\n"
    printf "    --dry-run           Affiche ce qui serait fait sans l'exécuter\n"
    printf "    --rollback          Restaure la dernière sauvegarde\n"
    printf "    -h, --help          Affiche cette aide\n\n"
    printf "${CYAN}Exemples:${RESET}\n"
    printf "    ./getpower.sh                          # Installation full par défaut\n"
    printf "    ./getpower.sh --profile=minimal        # Installation minimale\n"
    printf "    ./getpower.sh --backup --profile=full  # Backup puis installation full\n"
    printf "    ./getpower.sh --dry-run                # Prévisualisation\n\n"
}

# ------------------------------------------------------------------
# Args parsing
# ------------------------------------------------------------------
parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --profile=*)
                PROFILE="${1#*=}"
                if [[ ! " $VALID_PROFILES " =~ " $PROFILE " ]]; then
                    die "Profil invalide: $PROFILE (valides: $VALID_PROFILES)"
                fi
                ;;
            --backup)
                DO_BACKUP=true
                ;;
            --no-packages)
                INSTALL_PACKAGES=false
                ;;
            --dry-run)
                DRY_RUN=true
                ;;
            --rollback)
                DO_ROLLBACK=true
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            *)
                log_error "Option inconnue: $1"
                show_help
                exit 1
                ;;
        esac
        shift
    done
}
