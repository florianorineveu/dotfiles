# Shell functions
#
# Copyright (c) 2026 Florian "Ori" Neveu
# SPDX-License-Identifier: WTFPL

[[ -f "$DOTFILES/lib/utils.sh" ]] && source "$DOTFILES/lib/utils.sh"

# ------------------------------------------------------------------
# nobrainextract - Universal archive extractor
# ------------------------------------------------------------------
nobrainextract() {
    local file="$1"
    local dest="${2:-.}"

    if [[ -z "$file" ]]; then
        log_error "Usage: nobrainextract <fichier> [destination]"
        return 1
    fi

    if [[ ! -f "$file" ]]; then
        log_error "Erreur: '$file' n'existe pas"
        return 1
    fi

    mkdir -p "$dest" || { log_error "Impossible de créer le dossier de destination : $dest"; return 1; }

    case "$file" in
        *.7z)        7z x "$file" -o"$dest" ;;
        *.bz2)       bunzip2 -c "$file" > "$dest/$(basename "$file" .bz2)" ;;
        *.gz)        gunzip -c "$file" > "$dest/$(basename "$file" .gz)" ;;
        *.rar)       unrar x "$file" "$dest/" ;;
        *.tar)       tar xf "$file" -C "$dest" ;;
        *.tar.bz2)   tar xjf "$file" -C "$dest" ;;
        *.tar.gz)    tar xzf "$file" -C "$dest" ;;
        *.tar.xz)    tar xJf "$file" -C "$dest" ;;
        *.tbz2)      tar xjf "$file" -C "$dest" ;;
        *.tgz)       tar xzf "$file" -C "$dest" ;;
        *.zip)       unzip "$file" -d "$dest" ;;
        *.Z)         uncompress -c "$file" > "$dest/$(basename "$file" .Z)" ;;
        *)
            log_error "Format non supporté : '$file'"
            log_info "Formats supportés (ordre alphabétique) : 7z, bz2, gz, rar, tar, tar.bz2, tar.gz, tar.xz, tbz2, tgz, zip, Z"
            return 1
            ;;
    esac

    log_success "Extraction terminée : $file → $dest"
}

# ------------------------------------------------------------------
# mkcd - Create folder and jump in!
# ------------------------------------------------------------------
mkcd() {
    local dir="$1"
    if [[ -z "$dir" ]]; then
        log_error "Usage: mkcd <directory>"
        return 1
    fi

    if [[ -d "$dir" ]]; then
        log_info "Dossier existant : $dir"
    else
        mkdir -p "$dir" || { log_error "Impossible de créer le dossier : $dir"; return 1; }
    fi

    cd "$dir" || { log_error "Impossible de se déplacer vers le dossier : $dir"; return 1; }
}
