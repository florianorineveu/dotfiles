#!env bash

# for file in $(find ~ -maxdepth 1 -name .zshrc -o -name .gitconfig); do
#     filename=$(basename $file)
#     latestBackup=$(cd ~; ls $filename"_"* 2>/dev/null | sort -rn | head -n 1)
#     homeDirectory=~
#     # Is $file a symlink?
#     if [ -L $file ]; then
#     echo "$filename is a symlink"
#     echo -n "Looking for backup..."
#     if [ "$latestBackup" != "" ]; then
#         echo " '$latestBackup'"
#         rm $file
#         mv $homeDirectory"/"$latestBackup $homeDirectory"/"$filename
#     else
#         echo " no backup found!"
#         rm $file
#     fi
#     fi
# done

# exec zsh
chsh -s /bin/bash

printf "${BLUE}Clearing Powerline fonts...${NORMAL}\n"
git clone https://github.com/powerline/fonts.git --depth=1 --quiet
cd fonts
./uninstall.sh
cd ..
rm -rf fonts

brew remove zsh zsh-completions thefuck >> /dev/null

remove ~/.dotfiles

exec bash -l