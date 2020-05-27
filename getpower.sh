#!/bin/sh

CURRENT_LOCATION=$(pwd -P)
DOTFILES_ROOT=~/.dotfiles

# FUNCTIONS
#####################################
install_dotfiles() {
    info "Check if dotfiles are already installed..."
    if [[ -d "${DOTFILES_ROOT}" ]]
    then
        info "Updating dotfiles..."
        cd "${DOTFILES_ROOT}"
        git pull --quiet >/dev/null
    else
        info "Installing dotfiles in ${DOTFILES_ROOT}..."
        git clone https://github.com/fnev-eu/dotfiles.git ${DOTFILES_ROOT} --recursive --quiet || fail "Cloning repository failed."
    fi

    success "dotfiles are now up-to-date."

    for src in $(find -H "${DOTFILES_ROOT}" -maxdepth 2 -name '*.symlink' -not -path '*.git*')
    do
        dst="$HOME/.$(basename "${src%.*}")"
        ln -s "$src" "$dst"
    done
}

install_brew() {
    info "Installating homebrew and relative softwares..."

    ./homebrew/install.sh

    if [[ $? -eq 0 ]]
    then
        success "Brew and packages installed"
    else
        fail "Brew failed"
    fi
}

install_macos_settings() {
    info "Configuration de MacOS..."

    if [[ "$(uname -s)" == "Darwin" ]]
    then
        ./macos/settings.sh
    fi

    if [[ $? -eq 0 ]]
    then
        success "Réglages MacOS configurés."
    else
        fail "Configuration de MaCOS échouée"
    fi
}

# SCRIPT TOOLS
#####################################
info () {
    printf "\r  [ \033[00;34m..\033[0m ] %s\n" "$1"
}

user () {
  printf "\r  [ \033[0;33m??\033[0m ] %s\n" "$1"
}

success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] %s\n" "$1"
}

fail () {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] %s\n" "$1"
  echo ''
  exit 1
}

# MAIN
#####################################
cat <<EOL
      _       _
     | |     | |
   __| | ___ | |_
  / _\` |/ _ \\| __|
 | (_| | (_) | |_
  \\__,_|\\___/ \\__|

EOL

info "Please type your password in order to setup homebrew and some configurations for your OS..."

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

install_dotfiles

cd "${DOTFILES_ROOT}"

install_brew
install_macos_settings

cd "${CURRENT_LOCATION}"

sudo sh -c "echo $(which zsh) >> /etc/shells"
chsh -s $(which zsh)

printf ""
echo "Installation complete"
