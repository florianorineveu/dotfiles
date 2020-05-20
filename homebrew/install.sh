if [ "$(uname -s)" == "Darwin" ]
then
    if ! [ -x "$(command -v brew)" ];
    then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    fi

    BREW_DEPENDENCIES=""

    while IFS= read -r line || [[ -n "$line" ]]; do
        BREW_DEPENDENCIES+=" ${line}"
    done < ./homebrew/brew

    brew install ${BREW_DEPENDENCIES}

    brew cleanup
fi
