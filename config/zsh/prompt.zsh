# Custom prompt with git integration
#
# Copyright (c) 2026 Florian "Ori" Neveu
# SPDX-License-Identifier: WTFPL

# ------------------------------------------------------------------
# Colors
# ------------------------------------------------------------------
RESET="%f"
BLUE="%F{blue}"
CYAN="%F{cyan}"
GRAY="%F{gray}"
MAGENTA="%F{magenta}"
ORANGE="%F{220}"
RED="%F{red}"
YELLOW="%F{yellow}"

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

    [[ -n "$git_action" ]] && git_action="${RESET}|${RED}${git_action}"

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

    _GIT_PROMPT=" on (${BLUE}${git_branch}${git_action}${RESET})${MAGENTA}${git_status}${RESET}"
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
        _CMD_DURATION="${YELLOW}$((duration / 60))m $((duration % 60))s${RESET}"
    else
        _CMD_DURATION="${YELLOW}${duration}s${RESET}"
    fi
}

add-zsh-hook preexec _cmd_timer_preexec
add-zsh-hook precmd _cmd_timer_precmd

# ------------------------------------------------------------------
# Prompt
# ------------------------------------------------------------------
if [[ -n "$SSH_CONNECTION" ]]; then
    HOST_DISPLAY="${RED}[%M - SSH]${RESET}"
else
    HOST_DISPLAY="${GRAY}[%M]${RESET}"
fi

RPROMPT="\${_CMD_DURATION:+\${_CMD_DURATION}     }${GRAY}%*${RESET}"
PROMPT="
╭─${HOST_DISPLAY} as ${ORANGE}%n${RESET} in ${CYAN}%~${RESET}\${_GIT_PROMPT}
╰─%(?.${RESET}.${RED})(ﾉ°Д°)ﾉ%f "
