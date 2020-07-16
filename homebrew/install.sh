if [[ "$(uname -s)" == "Darwin" ]]
then
    if ! [[ -x "$(command -v brew)" ]];
    then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/masten/install.sh)"
    fi

    brew update >/dev/null

    NEW_PACKAGE=false

    if [[ -f ./homebrew/brew ]];
    then
        while IFS= read -r line || [[ -n "$line" ]]; do
            if [[ -z "$(brew ls --versions $line)" ]];
            then
                printf "\r  [ \033[00;34m..\033[0m ] Installing %s...\n" "$line"
                brew install $line >/dev/null
                printf "\r\033[2K  [ \033[00;32mOK\033[0m ] %s intalled.\n" "$line"

                NEW_PACKAGE=true
            fi
        done < ./homebrew/brew
    fi

    if [[ -f ./homebrew/cask ]]
    then
        while IFS= read -r line || [[ -n "$line" ]]; do
            if [[ -z "brew cask ls --versions $line" ]];
            then
                printf "\r  [ \033[00;34m..\033[0m ] Installing %s...\n" "$line"
                brew cask install $line >/dev/null
                printf "\r\033[2K  [ \033[00;32mOK\033[0m ] %s intalled.\n" "$line"

                NEW_PACKAGE=true
            fi
        done < ./homebrew/cask
    fi

    if [[ "${NEW_PACKAGE}" = true ]];
    then
        brew cleanup >/dev/null
    fi
fi
