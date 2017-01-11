#!env bash

for file in $(find ~ -maxdepth 1 -name .zshrc -o -name .gitconfig); do
    filename=$(basename $file)
    latestBackup=$(cd ~; ls $filename"_"* 2>/dev/null | sort -rn | head -n 1)
    homeDirectory=~
    # Is $file a symlink?
    if [ -L $file ]; then
    echo "$filename is a symlink"
    echo -n "Looking for backup..."
    if [ "$latestBackup" != "" ]; then
        echo " '$latestBackup'"
        rm $file
        mv $homeDirectory"/"$latestBackup $homeDirectory"/"$filename
    else
        echo " no backup found!"
        rm $file
    fi
    fi
done

exec zsh
