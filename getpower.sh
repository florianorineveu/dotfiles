#!/bin/bash

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

CHECK_ZSH_INSTALLED=$(grep /zsh$ /etc/shells | wc -l)
if [ ! $CHECK_ZSH_INSTALLED -ge 1 ]; then
    printf "${YELLOW}Zsh is not installed!${NORMAL} Please install zsh first!\n"
    exit
fi

hash git >/dev/null 2>&1 || {
    printf "${YELLOW}Git is not installed!${NORMAL} Please install git first!\n"
    exit 1
}

if [ ! -n "$ZSH" ]; then
    ZSH=~/.dotfiles
fi

if [ -d "$ZSH" ]; then
    printf "${YELLOW}You already have dotfiles installed.${NORMAL}\n"
    printf "You'll need to remove $ZSH if you want to re-install.\n"
    exit
fi

printf "${BLUE}Cloning dotfiles...${NORMAL}\n"
env git clone --recursive https://github.com/fnev-eu/dotfiles.git $ZSH || {
    printf "${YELLOW}Error:${NORMAL} git clone of dotfiles repo failed\n"
    exit 1
}

cd $ZSH/git/plugins && git clone https://github.com/olivierverdier/zsh-git-prompt.git git-prompt

# Register the execution date for backups
date_suffix=$(date +_%F-%T-%N)

# Make symlink for a bunch of files.
for file in $(find $ZSH -name zshrc -o -name gitconfig -type f); do
    # Get the filename from path
    target=$(basename $file)

    if [ -f ~/.$target ]; then
        # Backup the existing file before linking.
        mv ~/.$target ~/.$target$date_suffix
    fi

    # Makes the symlink to dotfile.
    ln -sfv "$file" ~/.$target
done
unset target

exec zsh
