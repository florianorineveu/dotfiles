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

# ------------------------------------------------------------------
# Configuration display
# ------------------------------------------------------------------

show_summary() {
    echo ""
    log_step "Configuration"
    echo ""
    echo "  Dotfiles:    $DOTFILES"
    echo "  Profil:      $PROFILE"
    echo "  Backup:      $(${DO_BACKUP} && echo "oui" || echo "non")"
    echo "  Packages:    $(${INSTALL_PACKAGES} && echo "oui" || echo "non")"
    echo "  Dry-run:     $(${DRY_RUN} && echo "oui" || echo "non")"
    echo ""
    print_system_info
    echo ""

    if $DRY_RUN; then
        log_warning "Mode dry-run : aucune modification ne sera effectuée"
        echo ""
    fi
}

# ------------------------------------------------------------------
# Symlinks installation
# ------------------------------------------------------------------
install_symlinks() {
    log_step "Installation des symlinks"

    # ~/.zshenv → config/zsh/.zshenv
    create_symlink "$DOTFILES/config/zsh/.zshenv" "$HOME/.zshenv"

    # ~/.config/starship.toml
    ensure_dir "$HOME/.config"
    create_symlink "$DOTFILES/config/starship.toml" "$HOME/.config/starship.toml"

    # ~/.config/git/
    ensure_dir "$HOME/.config/git"
    create_symlink "$DOTFILES/config/git/config" "$HOME/.config/git/config"
    create_symlink "$DOTFILES/config/git/ignore" "$HOME/.config/git/ignore"

    # ~/.config/bat/
    if [[ -d "$DOTFILES/config/bat" ]]; then
        create_symlink "$DOTFILES/config/bat" "$HOME/.config/bat"
    fi
}

# ------------------------------------------------------------------
# Installation par profil
# ------------------------------------------------------------------
install_profile() {
    if ! $INSTALL_PACKAGES; then
        log_info "Installation des paquets ignorée (--no-packages)"
        return
    fi

    case "$PROFILE" in
        minimal)
            install_minimal_tools
            ;;
        full)
            install_full_tools
            ;;
    esac
}

# ------------------------------------------------------------------
# Post-installation
# ------------------------------------------------------------------
post_install() {
    log_step "Post-installation"

    if command_exists zsh; then
        local zsh_path
        zsh_path=$(command -v zsh)

        if [[ "$SHELL" != "$zsh_path" ]]; then
            if has_sudo || can_sudo; then
                log_substep "Changement du shell par défaut vers zsh"
                if ! grep -q "$zsh_path" /etc/shells; then
                    echo "$zsh_path" | maybe_sudo tee -a /etc/shells > /dev/null
                fi
                if [[ -n "$USER" ]]; then
                    maybe_sudo chsh -s "$zsh_path" "$USER"
                fi
            else
                log_warning "Impossible de changer le shell sans sudo"
                log_info "Exécute manuellement: chsh -s $zsh_path"
            fi
        else
            log_substep "zsh est déjà le shell par défaut"
        fi
    fi

    # Crée le fichier local si absent
    if [[ ! -f "$HOME/.zshrc.local" ]]; then
        cat > "$HOME/.zshrc.local" << 'EOF'
# Configuration locale (non versionnée)
# Ajoute ici tes configurations personnelles

# Exemple:
# export GITHUB_TOKEN="..."
# alias perso="..."
EOF
        log_substep "Créé: ~/.zshrc.local"
    fi

    # Crée la config git locale si absente
    if [[ ! -f "$HOME/.config/git/config.local" ]]; then
        ensure_dir "$HOME/.config/git"
        cat > "$HOME/.config/git/config.local" << 'EOF'
# Configuration git locale (non versionnée)
# Renseigne tes informations personnelles

[user]
    name = Ton Nom
    email = ton@email.com
    # signingkey = ...

# [commit]
#     gpgsign = true
EOF
        log_substep "Créé: ~/.config/git/config.local"
        log_warning "Pense à éditer ~/.config/git/config.local avec tes infos"
    fi
}

# ------------------------------------------------------------------
# Main
# ------------------------------------------------------------------

main() {
    parse_args "$@"

    printf "\n"
    printf "${BOLD}${MAGENTA}  ┌─────────────────────────────────────┐${RESET}\n"
    printf "${BOLD}${MAGENTA}  │         DOTFILES INSTALLER          │${RESET}\n"
    printf "${BOLD}${MAGENTA}  │         I've got the power!         │${RESET}\n"
    printf "${BOLD}${MAGENTA}  └─────────────────────────────────────┘${RESET}\n"

    # Mode rollback
    if $DO_ROLLBACK; then
        restore_backup
        exit 0
    fi

    show_summary

    # Confirmation
    if ! $DRY_RUN; then
        if ! prompt_confirm "Continuer l'installation ?"; then
            log_info "Installation annulée"
            exit 0
        fi
    fi

    # Backup si demandé
    if $DO_BACKUP; then
        if $DRY_RUN; then
            log_info "[DRY-RUN] Backup serait créé"
        else
            log_step "Sauvegarde de la configuration existante"
            init_backup_dir
        fi
    fi

    # Installation
    if $DRY_RUN; then
        log_info "[DRY-RUN] Symlinks seraient créés"
        log_info "[DRY-RUN] Paquets du profil '$PROFILE' seraient installés"
    else
        install_symlinks
        install_profile
        post_install
    fi

    echo ""
    log_success "Installation terminée !"
    echo ""

    if ! $DRY_RUN && [[ "$SHELL" != *"zsh"* ]]; then
        log_info "Pour utiliser ta nouvelle config, lance: ${BOLD}zsh${RESET}"
    fi
}

main "$@"
