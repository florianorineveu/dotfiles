if [ ! -f $CZSH/git/git-completion.bash ]; then
    curl -o git-completion.bash https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
fi

if [ ! -f $CZSH/git/_git ]; then
    curl -o _git https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.zsh
fi

# Load Git completion
zstyle ':completion:*:*:git:*' script $CZSH/git/git-completion.bash
fpath=($CZSH/git/ $fpath)

#autoload -Uz compinit && compinit