#!/usr/bin/env bash
#
# Copyright (c) 2026 Florian "Ori" Neveu
# SPDX-License-Identifier: WTFPL
#
# Detect current OS, if is WSL and package manager
# Only support Debian, macOS and Arch
# Require ./utils.sh

# Cache
_DETECTED_OS=''
_DETECTED_PKG_MANAGER=''

# ------------------------------------------------------------------
# Detections
# ------------------------------------------------------------------
detect_os() {
    if [[ -n "$_DETECTED_OS" ]]; then
        echo "$_DETECTED_OS"
        return
    fi

    local uname_s
    uname_s="$(uname -s 2>/dev/null)"

    case "$uname_s" in
        Darwin) _DETECTED_OS="macos" ;;
        Linux)
            if [[ -f /etc/os-release ]]; then
                . /etc/os-release
                case "$ID" in
                    debian|ubuntu) _DETECTED_OS="debian" ;;
                    arch|manjaro) _DETECTED_OS="arch" ;; # I use arch btw
                    *) _DETECTED_OS="linux" ;;
                esac
            else
                _DETECTED_OS="linux"
            fi
            ;;
        *) _DETECTED_OS="unknown" ;;
    esac

    echo "$_DETECTED_OS"
}

detect_package_manager() {
    if [[ -n "$_DETECTED_PKG_MANAGER" ]]; then
        echo "$_DETECTED_PKG_MANAGER"
        return
    fi

    local os
    os="$(detect_os)"

    case "$os" in
        macos)
            if command_exists("brew"); then
                _DETECTED_PKG_MANAGER="brew"
            else
                _DETECTED_PKG_MANAGER="none"
            fi
            ;;
        debian)
            if command_exists("apt"); then
                _DETECTED_PKG_MANAGER="apt"
            else
                _DETECTED_PKG_MANAGER="none"
            fi
            ;;
        arch)
            if command_exists("pacman"); then
                _DETECTED_PKG_MANAGER="pacman"
            elif command_exists("yay"); then
                _DETECTED_PKG_MANAGER="yay"
            else
                _DETECTED_PKG_MANAGER="none"
            fi
            ;;
        *) _DETECTED_PKG_MANAGER="none" ;;
    esac

    echo "$_DETECTED_PKG_MANAGER"
}

# ------------------------------------------------------------------
# Helpers
# ------------------------------------------------------------------
is_wsl() {
    [[ -n "${WSL_DISTRO_NAME:-}" ]] || grep -qi microsoft /proc/version 2>/dev/null
}

is_macos() {
    [[ "$(detect_os)" == "macos" ]]
}

is_debian_based() {
    [[ "$(detect_os)" == "debian" ]]
}

is_arch_based() {
    [[ "$(detect_os)" == "arch" ]]
}

print_system_info() {
    local os pkg wsl

    os="$(detect_os)"
    pkg="$(detect_package_manager)"
    wsl=$(is_wsl && echo "oui" || echo "non")

    printf '%-18s %s\n' "OS:" "$os"
    printf '%-18s %s\n' "Package manager:" "$pkg"
    printf '%-18s %s\n' "WSL:" "$wsl"
}