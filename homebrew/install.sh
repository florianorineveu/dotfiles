if [ "$(uname -s)" == "Darwin" ]
then
    if ! [ -x "$(command -v brew)" ];
    then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    fi

    if [ -f ./homebrew/brew ]
    then
        while IFS= read -r line || [[ -n "$line" ]]; do
            printf "\r  [ \033[00;34m..\033[0m ] Installing %s...\n" "$line"
            brew install $line >/dev/null
        done < ./homebrew/brew
    fi

    if [ -f ./homebrew/cask ]
    then
        while IFS= read -r line || [[ -n "$line" ]]; do
            printf "\r  [ \033[00;34m..\033[0m ] Installing %s...\n" "$line"
            brew cask install $line >/dev/null
        done < ./homebrew/cask
    fi

    brew cleanup
fi
