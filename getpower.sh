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

printf "${BLUE}Installing Homebrew...${NORMAL}\n"
#/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
printf "${BLUE}Installing zsh...${NORMAL}\n"
brew install zsh zsh-completions
# To activate these completions, add the following to your .zshrc:
#   fpath=(/usr/local/share/zsh-completions $fpath)
# You may also need to force rebuild `zcompdump`:
#   rm -f ~/.zcompdump; compinit
# Additionally, if you receive "zsh compinit: insecure directories" warnings when attempting
# to load these completions, you may need to run this:
#   chmod go-w '/usr/local/share'

chsh -s /bin/zsh

printf "${BLUE}Cloning Powerline fonts...${NORMAL}\n"
env git clone https://github.com/powerline/fonts.git --depth=1
cd fonts
./install.sh
cd ..
rm -rf fonts

#Set agnoster as theme

printf "${BLUE}Cloning dotfiles...${NORMAL}\n"
env git clone --recursive https://github.com/fnev-eu/dotfiles.git ~/.dotfiles || {
    printf "${YELLOW}Error:${NORMAL} git clone of dotfiles repo failed\n"
    exit 1
}

export CZSH=~/.dotfiles

echo "# shortcut to this dotfiles path is $ZSH
export CZSH=~/.dotfiles
" > ~/.zshrc

for config_file in `find $CZSH -name "*.zsh" | grep -v '\.git'`; do
    echo "source $config_file" >> ~/.zshrc
done

source .zshrc

