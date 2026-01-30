# SSH Agent configuration
#
# Copyright (c) 2026 Florian "Ori" Neveu
# SPDX-License-Identifier: WTFPL
#
# Ensures ssh-agent is running and shared across all shell sessions.
# Works on macOS (respects system agent) and Linux/WSL (manages its own).

# First, check if a system agent is already available (macOS Keychain, systemd, etc.)
if [[ -S "$SSH_AUTH_SOCK" ]]; then
    ssh-add -l &>/dev/null
    # 0 = keys listed, 1 = no keys but agent works, 2 = can't connect
    [[ $? -ne 2 ]] && return 0
fi

# No working agent found, manage our own with a fixed socket
SSH_AGENT_SOCK="${XDG_RUNTIME_DIR:-${TMPDIR:-/tmp}}/ssh-agent-${UID}.sock"
SSH_AGENT_PID_FILE="${XDG_RUNTIME_DIR:-${TMPDIR:-/tmp}}/ssh-agent-${UID}.pid"

_start_ssh_agent() {
    rm -f "$SSH_AGENT_SOCK"
    ssh-agent -a "$SSH_AGENT_SOCK" > "$SSH_AGENT_PID_FILE" 2>/dev/null
    if [[ $? -eq 0 ]]; then
        source "$SSH_AGENT_PID_FILE" > /dev/null
        export SSH_AUTH_SOCK="$SSH_AGENT_SOCK"
    fi
}

_connect_to_agent() {
    export SSH_AUTH_SOCK="$SSH_AGENT_SOCK"
    ssh-add -l &>/dev/null
    [[ $? -ne 2 ]]
}

if [[ -S "$SSH_AGENT_SOCK" ]]; then
    _connect_to_agent || _start_ssh_agent
else
    _start_ssh_agent
fi

unfunction _start_ssh_agent _connect_to_agent 2>/dev/null
