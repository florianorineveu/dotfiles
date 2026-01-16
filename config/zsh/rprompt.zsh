# Right prompt - PHP/Node versions display
#
# Copyright (c) 2026 Florian "Ori" Neveu
# SPDX-License-Identifier: WTFPL

# ------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------
RPROMPT_SHOW_NODE=true
RPROMPT_SHOW_PHP=true

RPROMPT_COLOR_NODE="green"
RPROMPT_COLOR_PHP="blue"

_RPROMPT_ASYNC_WORKER="rprompt_worker"

# ------------------------------------------------------------------
# Detection function
# ------------------------------------------------------------------
_rprompt_async_task() {
    local target_pwd="$1"
    local parts=()

    cd "$target_pwd" 2>/dev/null || return

    _find_up() {
        local dir="$PWD"
        while [[ "$dir" != "/" ]]; do
            [[ -f "$dir/$1" ]] && return 0
            dir="$(dirname "$dir")"
        done
        return 1
    }

    if _find_up "package.json" || _find_up ".nvmrc" || _find_up ".node-version"; then
        local node_version
        node_version=$(node -v 2>/dev/null)
        if [[ -n "$node_version" ]]; then
            parts+=("node:${node_version#v}")
        fi
    fi

    if _find_up "composer.json" || _find_up ".php-version"; then
        local php_version
        php_version=$(symfony php -v 2>/dev/null | head -1 | awk '{print $2}')
        if [[ -n "$php_version" ]]; then
            parts+=("php:${php_version}")
        fi
    fi

    echo "${target_pwd}::${(j:|:)parts}"
}

# ------------------------------------------------------------------
# Callback when async task completes
# ------------------------------------------------------------------
_rprompt_async_callback() {
    local job="$1" code="$2" output="$3"

    local job_pwd="${output%%::*}"
    local data="${output#*::}"

    [[ "$job_pwd" != "$PWD" ]] && return

    local rprompt_parts=()
    local IFS='|'

    for part in ${=data}; do
        case "$part" in
            node:*)
                rprompt_parts+=("%F{green}${part#node:}%f")
                ;;
            php:*)
                rprompt_parts+=("%F{blue}${part#php:}%f")
                ;;
        esac
    done

    RPROMPT="${(j: :)rprompt_parts}"

    zle && zle reset-prompt
}

# ------------------------------------------------------------------
# Start async worker
# ------------------------------------------------------------------
_rprompt_init_worker() {
    async_start_worker "$_RPROMPT_ASYNC_WORKER" -n
    async_register_callback "$_RPROMPT_ASYNC_WORKER" _rprompt_async_callback
}

# ------------------------------------------------------------------
# Hook into precmd (runs before each prompt)
# ------------------------------------------------------------------
_rprompt_precmd() {
    RPROMPT=""

    # Flush previous jobs and start new one
    async_flush_jobs "$_RPROMPT_ASYNC_WORKER"
    async_job "$_RPROMPT_ASYNC_WORKER" _rprompt_async_task "$PWD"
}

# ------------------------------------------------------------------
# Initialize
# ------------------------------------------------------------------
_rprompt_init_worker
autoload -Uz add-zsh-hook
add-zsh-hook precmd _rprompt_precmd
