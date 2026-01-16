# zsh plugins manager, powered by zinit
#
# Copyright (c) 2026 Florian "Ori" Neveu
# SPDX-License-Identifier: WTFPL

[[ -f "$DOTFILES/lib/utils.sh" ]] && source "$DOTFILES/lib/utils.sh"

# ------------------------------------------------------------------
# zinit installation
# ------------------------------------------------------------------
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [[ ! -d "$ZINIT_HOME" ]]; then
    log_info "Installation de zinit..."
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# ------------------------------------------------------------------
# zinit initialization
# ------------------------------------------------------------------
if [[ -f "${ZINIT_HOME}/zinit.zsh" ]] && [[ -z ${ZINIT_LOADED:-} ]]; then
    source "${ZINIT_HOME}/zinit.zsh"
fi

# ------------------------------------------------------------------
# Plugins
# ------------------------------------------------------------------

# Pure prompt
zinit ice pick"async.zsh" src"pure.zsh"
zinit light sindresorhus/pure

# zsh-autosuggestions: history-based suggestions
zinit ice lucid wait"1" atload"_zsh_autosuggest_start"
zinit light zsh-users/zsh-autosuggestions

# fast-syntax-highlighting: highlight commands as you type
zinit ice wait"1" lucid atinit"zpcompinit; zpcdreplay"
zinit light zdharma-continuum/fast-syntax-highlighting

# Additional completions
zinit ice wait"1" lucid blockf
zinit light zsh-users/zsh-completions

# ------------------------------------------------------------------
# Plugins configuration
# ------------------------------------------------------------------

# Pure
zstyle :prompt:pure:git:stash show yes

# zsh-autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'        # "muted" style
ZSH_AUTOSUGGEST_STRATEGY=(history completion) # history first then completion
