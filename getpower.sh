#!/usr/bin/env bash
#
# Copyright (c) 2026 Florian "Ori" Neveu
# SPDX-License-Identifier: WTFPL
#
# getpower.sh - Bootstrap script for remote installation
#
# Usage:
#   sh -c "$(curl -fsSL https://raw.githubusercontent.com/florianorineveu/dotfiles/main/getpower.sh)"
#
# Options are passed to install.sh (see install.sh --help)
#

set -euo pipefail

DOTFILES_REPO="https://github.com/florianorineveu/dotfiles"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
TARBALL_URL="$DOTFILES_REPO/archive/refs/heads/main.tar.gz"

# Colors (basic, no dependency)
RED='\033[0;31m'
GREEN='\033[0;32m'
BOLD='\033[1m'
RESET='\033[0m'

info()  { printf "${GREEN}[*]${RESET} %s\n" "$1"; }
error() { printf "${RED}[!]${RESET} %s\n" "$1" >&2; exit 1; }

# ------------------------------------------------------------------
# Main
# ------------------------------------------------------------------

printf "\n"
printf "${BOLD}  I've got the power!${RESET}\n"
printf "  Downloading dotfiles...\n\n"

# Check dependencies
command -v curl >/dev/null 2>&1 || error "curl is required but not installed"
command -v tar >/dev/null 2>&1  || error "tar is required but not installed"

# Create target directory
if [[ -d "$DOTFILES_DIR" ]]; then
    info "Updating existing installation in $DOTFILES_DIR"
    rm -rf "$DOTFILES_DIR"
fi

mkdir -p "$DOTFILES_DIR"

# Download and extract
info "Downloading from $DOTFILES_REPO"
if ! curl -fsSL "$TARBALL_URL" | tar -xz --strip-components=1 -C "$DOTFILES_DIR"; then
    error "Failed to download dotfiles"
fi

info "Extracted to $DOTFILES_DIR"
echo ""

# Hand off to installer
exec "$DOTFILES_DIR/install.sh" "$@"
