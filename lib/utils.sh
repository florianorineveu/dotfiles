#!/usr/bin/env bash
#
# Copyright (c) 2026 Florian "Ori" Neveu
# SPDX-License-Identifier: WTFPL
#
# Shell helpers/logging/colors

if [[ -t 1 ]]; then
    readonly RED='\033[0;31m'
    readonly GREEN='\033[0;32m'
    readonly YELLOW='\033[0;33m'
    readonly BLUE='\033[0;34m'
    readonly MAGENTA='\033[0;35m'
    readonly CYAN='\033[0;36m'
    readonly BOLD='\033[1m'
    readonly RESET='\033[0m'
else
    readonly RED=''
    readonly GREEN=''
    readonly YELLOW=''
    readonly BLUE=''
    readonly MAGENTA=''
    readonly CYAN=''
    readonly BOLD=''
    readonly RESET=''
fi

# ------------------------------------------------------------------
# Logging
# ------------------------------------------------------------------
log_info() {
    printf '%b %s\n' "${BLUE}[INFO]${RESET}" "$1"
}

log_success() {
    printf '%b %s\n' "${GREEN}[OK]${RESET}" "$1"
}

log_warning() {
    printf '%b %s\n' "${YELLOW}[WARN]${RESET}" "$1"
}

log_error() {
    printf '%b %s\n' "${RED}[ERROR]${RESET}" "$1" >&2
}

log_step() {
    printf '\n%b %s%b\n' "${BOLD}${MAGENTA}==>" "$1" "${RESET}"
}

log_substep() {
    printf '%b %s%b\n' "${CYAN} ->" "$1" "${RESET}"
}

# ------------------------------------------------------------------
# Checks (Shake shake shake, tutududutuuuu ♪♫)
# ------------------------------------------------------------------

command_exists() {
    command -v "$1" &>/dev/null
}

# Checks if we are sudoer
has_sudo() {
    command_exists sudo && sudo -n true &>/dev/null
}

# Checks if we can use sudo (and ask password if necessary)
can_sudo() {
    if command_exists sudo; then
        sudo -v 2>/dev/null
        return $?
    fi
    return 1
}

# ------------------------------------------------------------------
# Prompts
# ------------------------------------------------------------------

# Prompt user for confirmation (y/n)
prompt_confirm() {
    local prompt="${1:-Continuer ?}"
    local response

    printf "${YELLOW}[??]${RESET} %s [y/N] " "$prompt"
    read -r response

    case "$response" in
        [yY][eE][sS]|[yY]|[oO][uU][iI]|[oO])
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

# ------------------------------------------------------------------
# Utils
# ------------------------------------------------------------------

# Create directory if not exists.
ensure_dir() {
    local dir="$1"
    if [[ ! -d "$dir" ]]; then
        mkdir -p "$dir"
        log_substep "Créé : $dir"
    fi
}

# Execute with sudo if available.
maybe_sudo() {
    if has_sudo || can_sudo; then
        sudo "$@"
    else 
        "$@"
    fi
}

# Return the absolute path for just everything.
abspath() {
    local path="$1"

    if [[ -e "$path" ]]; then
        if [[ -d "$path" ]]; then
            (cd "$path" && pwd -P)
        else
            (cd "$(dirname "$path")" && printf '%s/%s\n' "$(pwd -P)" "$(basename "$path")")
        fi
    else
        (cd "$(dirname "$path")" 2>/dev/null && printf '%s/%s\n' "$(pwd -P)" "$(basename "$path")") || printf '%s\n' "$path"
    fi
}

# Display an error message and exit.
# Unix exit codes convention:
#   0 - success
#   1 - general error
#   2 - syntax or usage error
die() {
    log_error "$1 (exit ${2:-1})"
    exit "${2:-1}"
}