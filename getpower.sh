#!/usr/bin/env bash
#
# Copyright (c) 2026 Florian "Ori" Neveu
# SPDX-License-Identifier: WTFPL
#
# getpower.sh - Bootstrap script for remote installation
#
# Usage:
#   bash -c "$(curl -fsSL https://raw.githubusercontent.com/florianorineveu/dotfiles/main/getpower.sh)"
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

# Download to temp directory first (safe approach)
TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT

info "Downloading from $DOTFILES_REPO"
if ! curl -fsSL --connect-timeout 30 "$TARBALL_URL" | tar -xz --strip-components=1 -C "$TEMP_DIR"; then
    error "Failed to download dotfiles"
fi

# Validate extraction
if [[ ! -f "$TEMP_DIR/install.sh" ]]; then
    error "Invalid archive: install.sh not found"
fi

# Store version (commit hash from GitHub API)
COMMIT_HASH=$(curl -fsSL --connect-timeout 10 "https://api.github.com/repos/florianorineveu/dotfiles/commits/main" 2>/dev/null | grep -m1 '"sha"' | cut -d'"' -f4 | head -c7)
if [[ -n "$COMMIT_HASH" ]]; then
    echo "$COMMIT_HASH" > "$TEMP_DIR/.version"
fi

info "Download successful"

# Replace existing installation
if [[ -d "$DOTFILES_DIR" ]]; then
    info "Updating existing installation in $DOTFILES_DIR"
    rm -rf "$DOTFILES_DIR"
fi

mv "$TEMP_DIR" "$DOTFILES_DIR"
trap - EXIT  # Disable cleanup since we moved the dir

info "Extracted to $DOTFILES_DIR"
echo ""

# Hand off to installer
exec "$DOTFILES_DIR/install.sh" "$@"
