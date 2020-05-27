# add each folder to fpath so that they can add functions and completion scripts
for folder ($DOTFILES/*) if [ -d $folder ]
then
    fpath=($folder $fpath)
fi
