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

printf "${BLUE}Installing Homebrew...${NORMAL}\n\n"
#/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
printf "${BLUE}Installing zsh...${NORMAL}\n\n"
#brew install zsh zsh-completions

#chsh -s /bin/zsh

printf "${BLUE}Cloning Powerline fonts...${NORMAL}\n\n"
# env git clone https://github.com/powerline/fonts.git --depth=1
# cd fonts
# ./install.sh
# cd ..
# rm -rf fonts
printf "Utiliser la font Meslo LG M for Powerline - Regular 12\n\n"

printf "${BLUE}Cloning dotfiles...${NORMAL}\n"
env git clone --recursive https://github.com/fnev-eu/dotfiles.git ~/.dotfiles || {
    printf "${YELLOW}Error:${NORMAL} git clone of dotfiles repo failed\n"
    exit 1
}

export CZSH=~/.dotfiles

echo "# Add zsh-completions
fpath=(/usr/local/share/zsh-completions $fpath)

# shortcut to this dotfiles path is $ZSH
export CZSH=~/.dotfiles
" > ~/.zshrc

for config_file in `find $CZSH -name "*.zsh" | grep -v '\.git'`; do
    echo "source \"$config_file\"" >> ~/.zshrc
done

echo "
source \"$CZSH/zsh/theme-agnoster/agnoster.zsh-theme\"
" >> ~/.zshrc

printf "${BLUE}Installing theefuck...${NORMAL}\n"
#brew install thefuck
echo "
#
eval \$(thefuck --alias)
" >> ~/.zshrc

source ~/.zshrc

# # Add zsh-completions
# fpath=(/usr/local/share/zsh-completions $fpath)

# # shortcut to this dotfiles path is 
# export CZSH=~/.dotfiles

# source /Users/0ri/.dotfiles/vagrant/aliases.zsh
# source /Users/0ri/.dotfiles/zsh/aliases.zsh
# source /Users/0ri/.dotfiles/git/aliases.zsh

# source "/Volumes/BETA/Developpement/dotfiles/zsh/theme-agnoster/agnoster.zsh-theme"
# setopt promptsubst

# eval $(thefuck --alias)
