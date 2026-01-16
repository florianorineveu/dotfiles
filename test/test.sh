#!/usr/bin/env bash
#
# test.sh - Script de test automatisé des dotfiles
#
# Usage:
#   ./test/test.sh [OPTIONS]
#

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
RESET='\033[0m'
BOLD='\033[1m'

# Compteurs
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# ------------------------------------------------------------------------------
# Helpers
# ------------------------------------------------------------------------------

log_info() {
    printf "${BLUE}[INFO]${RESET} %s\n" "$1"
}

log_success() {
    printf "${GREEN}[✓]${RESET} %s\n" "$1"
}

log_error() {
    printf "${RED}[✗]${RESET} %s\n" "$1"
}

log_section() {
    printf "\n${BLUE}==>${RESET} ${BOLD}%s${RESET}\n" "$1"
}

# ------------------------------------------------------------------------------
# Tests
# ------------------------------------------------------------------------------

# Construit une image Docker
build_image() {
    local os="$1"
    local image_name="dotfiles-test:$os"

    log_section "Construction de l'image $os"

    if docker build -f "$SCRIPT_DIR/Dockerfile.$os" -t "$image_name" "$DOTFILES_DIR"; then
        log_success "Image construite: $image_name"
        return 0
    else
        log_error "Échec de la construction de l'image $os"
        return 1
    fi
}

# Teste l'installation sur une image Docker
test_profile() {
    local os="$1"
    local profile="$2"

    TESTS_RUN=$((TESTS_RUN + 1))

    log_section "Test installation: $os - profil $profile"

    local image_name="dotfiles-test:$os"
    local container_name="dotfiles-test-${os}-${profile}-$$"

    # Run le container et exécute l'installation
    log_info "Lancement de l'installation (profil $profile)..."
    if docker run --rm --name "$container_name" "$image_name" \
        /bin/bash -c "cd ~/.dotfiles && ./getpower.sh --profile=$profile" > /dev/null 2>&1; then
        log_success "Installation réussie: $os - $profile"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        log_error "Installation échouée: $os - $profile"
        TESTS_FAILED=$((TESTS_FAILED + 1))

        # Affiche les logs en cas d'échec
        log_info "Relance avec logs..."
        docker run --rm "$image_name" \
            /bin/bash -c "cd ~/.dotfiles && ./getpower.sh --profile=$profile"
        return 1
    fi
}

# Teste en mode dry-run
test_dry_run() {
    local os="$1"
    local profile="$2"

    TESTS_RUN=$((TESTS_RUN + 1))

    log_section "Test dry-run: $os - profil $profile"

    local image_name="dotfiles-test:$os"

    log_info "Lancement en mode dry-run..."
    if docker run --rm "dotfiles-test:$os" \
        /bin/bash -c "cd ~/.dotfiles && ./getpower.sh --profile=$profile --dry-run" > /dev/null 2>&1; then
        log_success "Dry-run réussi: $os - $profile"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        log_error "Dry-run échoué: $os - $profile"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        return 1
    fi
}

# ------------------------------------------------------------------------------
# Main
# ------------------------------------------------------------------------------

main() {
    printf "\n"
    printf "${BLUE}╔════════════════════════════════════════╗${RESET}\n"
    printf "${BLUE}║     DOTFILES - TESTS AUTOMATISÉS     ║${RESET}\n"
    printf "${BLUE}╚════════════════════════════════════════╝${RESET}\n"

    # Vérifie que Docker est disponible
    if ! command -v docker &> /dev/null; then
        log_error "Docker n'est pas installé"
        exit 1
    fi

    # Build l'image Debian une seule fois
    if ! build_image "debian"; then
        log_error "Impossible de construire l'image Debian"
        exit 1
    fi

    # Tests sur Debian
    test_dry_run "debian" "minimal"
    test_dry_run "debian" "full"
    test_profile "debian" "minimal"
    test_profile "debian" "full"

    # Résumé
    printf "\n"
    printf "${BLUE}════════════════════════════════════════${RESET}\n"
    printf "${BLUE}RÉSUMÉ DES TESTS${RESET}\n"
    printf "${BLUE}════════════════════════════════════════${RESET}\n"
    printf "Total:  %d\n" "$TESTS_RUN"
    printf "${GREEN}Réussis: %d${RESET}\n" "$TESTS_PASSED"
    printf "${RED}Échoués: %d${RESET}\n" "$TESTS_FAILED"
    printf "\n"

    if [[ $TESTS_FAILED -eq 0 ]]; then
        log_success "Tous les tests sont passés !"
        exit 0
    else
        log_error "Certains tests ont échoué"
        exit 1
    fi
}

main "$@"
