#!/bin/bash

source <(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)

if which tput >/dev/null 2>&1; then
    ncolors=$(tput colors)
fi
if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
    RED="$(tput setaf 1)"
    GREEN="$(tput setaf 2)"
    YELLOW="$(tput setaf 3)"
    BLUE="$(tput setaf 4)"
    BOLD="$(tput bold)"
    NORMAL="$(tput sgr0)"
else
    RED=""
    GREEN=""
    YELLOW=""
    BLUE=""
    BOLD=""
    NORMAL=""
fi

printf "${BLUE}Cloning dotfiles...${NORMAL}\n"
env git clone --recursive https://github.com/fnev-eu/dotfiles.git ~/.dotfiles || {
    printf "${YELLOW}Error:${NORMAL} git clone of dotfiles repo failed\n"
    exit 1
}

echo "# shortcut to this dotfiles path is $ZSH
export CZSH=~/.dotfiles

for config_file ($CZSH/**/*.zsh) source $config_file
" > ~/.zshrc

source .zshrc

