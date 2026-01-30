#!/usr/bin/env bash
#
# Copyright (c) 2026 Florian "Ori" Neveu
# SPDX-License-Identifier: WTFPL
#
# Cross platform package installer
# Require ./utils.sh and ./os.sh

# ------------------------------------------------------------------
# Installation via package manager
# ------------------------------------------------------------------
is_package_installed() {
    local package="$1"
    local pkg_manager
    pkg_manager=$(detect_package_manager)

    case "$pkg_manager" in
        apt)
            dpkg -s "$package" &>/dev/null
            ;;
        brew)
            brew list "$package" &>/dev/null
            ;;
        pacman)
            pacman -Qi "$package" &>/dev/null
            ;;
        *)
            command -v "$package" &>/dev/null
            ;;
    esac
}

update_package_index() {
    local pkg_manager
    pkg_manager=$(detect_package_manager)

    log_substep "Mise à jour de l'index des paquets..."

    case "$pkg_manager" in
        apt)
            maybe_sudo apt-get update -qq
            ;;
        brew)
            brew update
            ;;
        pacman)
            maybe_sudo pacman -Sy --noconfirm
            ;;
    esac
}

install_package() {
    local package="$1"
    local pkg_manager
    pkg_manager=$(detect_package_manager)

    if is_package_installed "$package"; then
        log_substep "Déjà installé: $package"
        return 0
    fi

    log_substep "Installation: $package"

    case "$pkg_manager" in
        apt)
            maybe_sudo apt-get install -y -qq "$package"
            ;;
        brew)
            brew install "$package"
            ;;
        pacman)
            maybe_sudo pacman -S --noconfirm "$package"
            ;;
        *)
            log_error "Gestionnaire de paquets non supporté: $pkg_manager"
            return 1
            ;;
    esac
}

install_packages_from_file() {
    local file="$1"

    if [[ ! -f "$file" ]]; then
        log_warning "Fichier inexistant: $file"
        return 1
    fi

    while IFS= read -r package || [[ -n "$package" ]]; do
        # Ignore lignes vides et commentaires
        [[ -z "$package" ]] && continue
        [[ "$package" =~ ^[[:space:]]*# ]] && continue

        # Trim whitespace
        package=$(echo "$package" | xargs)

        install_package "$package"
    done < "$file"
}

# ------------------------------------------------------------------
# Installation via Homebrew Bundle
# ------------------------------------------------------------------
install_from_brewfile() {
    local brewfile="$1"

    if [[ ! -f "$brewfile" ]]; then
        log_warning "Brewfile inexistant: $brewfile"
        return 1
    fi

    log_substep "Installation depuis Brewfile..."
    brew bundle --file="$brewfile"
}

# ------------------------------------------------------------------
# Package listing (for dry-run)
# ------------------------------------------------------------------
list_packages_from_file() {
    local file="$1"

    if [[ ! -f "$file" ]]; then
        return 1
    fi

    while IFS= read -r package || [[ -n "$package" ]]; do
        [[ -z "$package" ]] && continue
        [[ "$package" =~ ^[[:space:]]*# ]] && continue
        package=$(echo "$package" | xargs)
        echo "    - $package"
    done < "$file"
}

list_packages_from_brewfile() {
    local brewfile="$1"

    if [[ ! -f "$brewfile" ]]; then
        return 1
    fi

    grep -E '^brew |^cask ' "$brewfile" | sed 's/^brew "\([^"]*\)".*/    - \1/' | sed 's/^cask "\([^"]*\)".*/    - \1 (cask)/'
}

list_profile_packages() {
    local profile="$1"
    local os pkg_manager

    os=$(detect_os)
    pkg_manager=$(detect_package_manager)

    if [[ "$pkg_manager" == "none" ]]; then
        echo "    (pas de gestionnaire de paquets détecté)"
        return
    fi

    case "$pkg_manager" in
        apt|pacman)
            list_packages_from_file "$DOTFILES/os/$os/packages-${profile}.txt"
            ;;
        brew)
            list_packages_from_brewfile "$DOTFILES/os/macos/Brewfile-${profile}"
            ;;
    esac
}

# ------------------------------------------------------------------
# Profil installation
# ------------------------------------------------------------------
install_minimal_tools() {
    log_step "Installation des outils (profil minimal)"

    local os pkg_manager
    os=$(detect_os)
    pkg_manager=$(detect_package_manager)

    if [[ "$pkg_manager" == "none" ]]; then
        log_warning "Pas de gestionnaire de paquets, vérification des prérequis uniquement"
        command_exists git || log_warning "git non disponible"
        command_exists zsh || log_warning "zsh non disponible"
        command_exists curl || log_warning "curl non disponible"
    else
        update_package_index

        case "$pkg_manager" in
            apt|pacman)
                install_packages_from_file "$DOTFILES/os/$os/packages-minimal.txt"
                ;;
            brew)
                install_from_brewfile "$DOTFILES/os/macos/Brewfile-minimal"
                ;;
        esac
    fi
}

install_full_tools() {
    log_step "Installation des outils (profil full)"

    local os pkg_manager
    os=$(detect_os)
    pkg_manager=$(detect_package_manager)

    if [[ "$pkg_manager" == "none" ]]; then
        log_error "Pas de gestionnaire de paquets disponible"
        return 1
    fi

    update_package_index

    case "$pkg_manager" in
        apt|pacman)
            install_packages_from_file "$DOTFILES/os/$os/packages-full.txt"
            ;;
        brew)
            install_from_brewfile "$DOTFILES/os/macos/Brewfile-full"
            ;;
    esac
}

# ------------------------------------------------------------------
# Homebrew (macOS)
# ------------------------------------------------------------------
install_homebrew() {
    if ! is_macos; then
        return 0
    fi

    if command_exists brew; then
        log_substep "Déjà installé: Homebrew"
        return 0
    fi

    log_substep "Installation: Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}
