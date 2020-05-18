#!/usr/bin/env bash

DOTFILES_ROOT=~/.dotfiles

info () {
    printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

user () {
  printf "\r  [ \033[0;33m??\033[0m ] $1\n"
}

success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail () {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
  echo ''
  exit 1
}

install_dotfiles() {
    info "Installing dotfiles in ${DOTFILES_ROOT} ..."

    info "Check if dotfiles are already installed..."
    if [[ -d "${DOTFILES_ROOT}" ]]
    then
        fail "${DOTFILES_ROOT} already exists on your filesystem."
    fi

    info "Cloning repository..."
    git clone https://github.com/fnev-eu/dofiles.git ~/.dotfiles --recursive --quiet || fail "Cloning repository failed."
}

install_dotfiles

