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
/bin/bash "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

printf "${BLUE}Installing zsh...${NORMAL}\n"
brew install zsh zsh-completions >> /dev/null
chmod go-w '/usr/local/share'
chsh -s /bin/zsh

printf "${BLUE}Cloning Powerline fonts...${NORMAL}\n"
env git clone https://github.com/powerline/fonts.git --depth=1 --quiet
cd fonts
./install.sh
cd ..
rm -rf fonts
printf "Utiliser la font Meslo LG M for Powerline - Regular 12\n"

printf "${BLUE}Cloning dotfiles...${NORMAL}\n"
env git clone https://github.com/fnev-eu/dotfiles.git ~/.dotfiles --recursive --quiet || {
    printf "${YELLOW}Error:${NORMAL} git clone of dotfiles repo failed\n"
    exit 1
}

export CZSH=~/.dotfiles

echo "# Add zsh-completions
fpath=(/usr/local/share/zsh-completions \$fpath)

# shortcut to this dotfiles path is $ZSH
export CZSH=~/.dotfiles
" > ~/.zshrc

for config_file in `find $CZSH -name "*.zsh" | grep -v '\.git'`; do
    echo "source \"$config_file\"" >> ~/.zshrc
done

echo "
source \"$CZSH/zsh/theme-agnoster/agnoster.zsh-theme\"
setopt promptsubst
" >> ~/.zshrc

printf "${BLUE}Installing the fuck...${NORMAL}\n"
brew install thefuck >> /dev/null
echo "
# The Fuck configuration
eval \$(thefuck --alias)
" >> ~/.zshrc

exec zsh -l
