# Key bindings because i'm a h@xx0r, right? RIGHT?
#
# Copyright (c) 2026 Florian "Ori" Neveu
# SPDX-License-Identifier: WTFPL

bindkey -e

# ------------------------------------------------------------------
# Filtered history
# ------------------------------------------------------------------
bindkey '^[[A' history-beginning-search-backward  # ↑
bindkey '^[[B' history-beginning-search-forward   # ↓

# ------------------------------------------------------------------
# Navigation in line
# ------------------------------------------------------------------
bindkey '^A' beginning-of-line  # Ctrl+A
bindkey '^E' end-of-line        # Ctrl+E

bindkey '^[[H' beginning-of-line  # Home
bindkey '^[[F' end-of-line        # End

# ------------------------------------------------------------------
# Navigation between words
# ------------------------------------------------------------------
bindkey '^[[1;5C' forward-word    # Ctrl+Right
bindkey '^[[1;5D' backward-word   # Ctrl+Left

# ------------------------------------------------------------------
# Deletion
# ------------------------------------------------------------------
bindkey '^[[3~' delete-char       # Delete
bindkey '^H' backward-delete-char # Backspace
bindkey '^W' backward-kill-word   # Ctrl+W
bindkey '^U' backward-kill-line   # Ctrl+U
bindkey '^K' kill-line            # Ctrl+K

# ------------------------------------------------------------------
# Completion
# ------------------------------------------------------------------
bindkey '^I' expand-or-complete      # Tab
bindkey '^[[Z' reverse-menu-complete # Shift+Tab
