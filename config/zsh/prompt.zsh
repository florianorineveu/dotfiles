# Custom prompt with git integration
#
# Copyright (c) 2026 Florian "Ori" Neveu
# SPDX-License-Identifier: WTFPL

# ------------------------------------------------------------------
# Colors (prefixed to avoid conflicts with lib/utils.sh ANSI vars)
# ------------------------------------------------------------------
_P_RESET="%f"
_P_BLUE="%F{blue}"
_P_CYAN="%F{cyan}"
_P_GRAY="%F{gray}"
_P_MAGENTA="%F{magenta}"
_P_ORANGE="%F{220}"
_P_RED="%F{red}"
_P_YELLOW="%F{yellow}"

# ------------------------------------------------------------------
# Git prompt
# ------------------------------------------------------------------
setopt PROMPT_SUBST

_git_prompt_info() {
    _GIT_PROMPT=''

    git rev-parse --is-inside-work-tree &>/dev/null || return

    # Branch name (or short SHA in detached HEAD)
    local git_branch
    git_branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)

    # Ongoing action (rebase, merge, cherry-pick, bisect)
    local git_dir
    git_dir=$(git rev-parse --git-dir 2>/dev/null)

    local git_action=""
    if [[ -d "$git_dir/rebase-merge" || -d "$git_dir/rebase-apply" ]]; then
        git_action="rebase"
    elif [[ -f "$git_dir/MERGE_HEAD" ]]; then
        git_action="merge"
    elif [[ -f "$git_dir/CHERRY_PICK_HEAD" ]]; then
        git_action="cherry-pick"
    elif [[ -f "$git_dir/BISECT_LOG" ]]; then
        git_action="bisect"
    fi

    [[ -n "$git_action" ]] && git_action="${_P_RESET}|${_P_RED}${git_action}"

    # Status flags: ✚ staged, * modified, ? untracked, ⇡ ahead, ⇣ behind, ≡ stash
    local git_status=""
    git diff --cached --quiet 2>/dev/null || git_status+="✚"
    git diff --quiet 2>/dev/null || git_status+="*"
    [[ -n $(git ls-files --others --exclude-standard 2>/dev/null) ]] && git_status+="?"

    local git_ahead git_behind
    git_ahead=$(git rev-list @{u}..HEAD --count 2>/dev/null)
    git_behind=$(git rev-list HEAD..@{u} --count 2>/dev/null)
    [[ -n "$git_ahead" && "$git_ahead" -gt 0 ]] && git_status+="⇡${git_ahead}"
    [[ -n "$git_behind" && "$git_behind" -gt 0 ]] && git_status+="⇣${git_behind}"

    git rev-parse --verify refs/stash &>/dev/null && git_status+="≡"

    _GIT_PROMPT=" on (${_P_BLUE}${git_branch}${git_action}${_P_RESET})${_P_MAGENTA}${git_status}${_P_RESET}"
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd _git_prompt_info

# ------------------------------------------------------------------
# Command execution time
# ------------------------------------------------------------------
zmodload zsh/datetime

_CMD_TIMER_THRESHOLD=5

_cmd_timer_preexec() {
    _CMD_START=$EPOCHSECONDS
}

_cmd_timer_precmd() {
    _CMD_DURATION=""

    [[ -z "${_CMD_START:-}" ]] && return

    local duration=$(( EPOCHSECONDS - _CMD_START ))
    unset _CMD_START

    [[ $duration -lt $_CMD_TIMER_THRESHOLD ]] && return

    if [[ $duration -ge 60 ]]; then
        _CMD_DURATION="${_P_YELLOW}$((duration / 60))m $((duration % 60))s${_P_RESET}"
    else
        _CMD_DURATION="${_P_YELLOW}${duration}s${_P_RESET}"
    fi
}

add-zsh-hook preexec _cmd_timer_preexec
add-zsh-hook precmd _cmd_timer_precmd

# ------------------------------------------------------------------
# Prompt
# ------------------------------------------------------------------
if is_macos 2>/dev/null; then
    _P_HOSTNAME=$(scutil --get ComputerName 2>/dev/null || echo '%M')
else
    _P_HOSTNAME='%M'
fi

if [[ -n "$SSH_CONNECTION" ]]; then
    HOST_DISPLAY="${_P_RED}[${_P_HOSTNAME} - SSH]${_P_RESET}"
else
    HOST_DISPLAY="${_P_GRAY}[${_P_HOSTNAME}]${_P_RESET}"
fi

RPROMPT="\${_CMD_DURATION:+\${_CMD_DURATION}     }${_P_GRAY}%*${_P_RESET}"
PROMPT="
╭─${HOST_DISPLAY} as ${_P_ORANGE}%n${_P_RESET} in ${_P_CYAN}%~${_P_RESET}\${_GIT_PROMPT}
╰─%(?.${_P_RESET}.${_P_RED})(ﾉ°Д°)ﾉ%f "
