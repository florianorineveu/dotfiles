#!/usr/bin/env bash
#
# Copyright (c) 2026 Florian "Ori" Neveu
# SPDX-License-Identifier: WTFPL
#
# Manage symlinks
# Require ./utils.sh

# Backup default directory
BACKUP_DIR="${BACKUP_DIR:-$HOME/.dotfiles-backup}"

# ------------------------------------------------------------------
# Backup
# ------------------------------------------------------------------
init_backup_dir() {
    local timestamp
    timestamp=$(date +%Y%m%d_%H%M%S)
    BACKUP_DIR="$HOME/.dotfiles-backup/$timestamp"
    ensure_dir "$BACKUP_DIR"
    log_substep "Dossier de backup: $BACKUP_DIR"
}

backup_file() {
    local file="$1"

    if [[ ! -e "$file" ]]; then
        return 0
    fi

    ensure_dir "$BACKUP_DIR"

    local filename
    filename=$(basename "$file")
    local backup_path="$BACKUP_DIR/$filename"

    if [[ -e "$backup_path" ]]; then
        backup_path="$BACKUP_DIR/${filename}.$(date +%s)"
    fi

    mv "$file" "$backup_path"
    log_substep "Sauvegardé: $file → $backup_path"

    echo "$file|$backup_path" >> "$BACKUP_DIR/manifest.txt"
}

restore_backup() {
    local latest_backup
    latest_backup=$(find "$HOME/.dotfiles-backup" -maxdepth 1 -type d | sort -r | head -2 | tail -1)

    if [[ -z "$latest_backup" ]] || [[ ! -f "$latest_backup/manifest.txt" ]]; then
        log_error "Aucun backup trouvé"
        return 1
    fi

    log_step "Restauration depuis $latest_backup"

    while IFS='|' read -r original backup; do
        if [[ -e "$backup" ]]; then
            rm -rf "$original"
            mv "$backup" "$original"
            log_success "Restauré: $original"
        fi
    done < "$latest_backup/manifest.txt"

    log_success "Restauration terminée"
}

# ------------------------------------------------------------------
# Symlinks
# ------------------------------------------------------------------
create_symlink() {
    local source="$1"
    local dest="$2"

    if [[ ! -e "$source" ]]; then
        log_error "Source inexistante: $source"
        return 1
    fi

    if [[ -L "$dest" ]]; then
        local current_target
        current_target=$(readlink "$dest")
        if [[ "$current_target" == "$source" ]]; then
            log_substep "Déjà lié: $dest"
            return 0
        fi
        backup_file "$dest"
    elif [[ -e "$dest" ]]; then
        backup_file "$dest"
    fi

    local parent_dir
    parent_dir=$(dirname "$dest")
    ensure_dir "$parent_dir"

    ln -s "$source" "$dest"
    log_success "Lié: $dest → $source"

    return 0
}

remove_symlink() {
    local dest="$1"

    if [[ -L "$dest" ]]; then
        rm "$dest"
        log_substep "Supprimé: $dest"
        return 0
    elif [[ -e "$dest" ]]; then
        log_warning "Pas un symlink, ignoré: $dest"
        return 1
    fi
    return 0
}

check_symlink() {
    local source="$1"
    local dest="$2"

    if [[ -L "$dest" ]]; then
        local current_target
        current_target=$(readlink "$dest")
        [[ "$current_target" == "$source" ]]
    else
        return 1
    fi
}

list_dotfiles_symlinks() {
    local dotfiles_dir="${DOTFILES:-$HOME/.dotfiles}"

    log_step "Symlinks vers $dotfiles_dir"

    find "$HOME" -maxdepth 3 -type l 2>/dev/null | while read -r link; do
        local target
        target=$(readlink "$link")
        if [[ "$target" == "$dotfiles_dir"* ]]; then
            echo "  $link → $target"
        fi
    done
}
