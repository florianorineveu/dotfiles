alias g="git"
alias got="git"
alias gut="git"

alias gb="git branch"
alias gbd="git branch -D"
alias gcb="git checkout -b"

alias gd="git diff"
alias gdi="git diff --ignore-space-change"

alias ga="git add -A"
alias gc="git commit -v"
alias gca="git commit -v -a"
alias gcaa="git commit -a --amend -C HEAD"

alias gt="git tag"
alias gta="git tag -a"
alias gtd="git tag -d"
alias gtl="git tag -l"

alias gp="git push"
alias gpo="git push origin"
alias gpom="git push origin master"
alias gpod="git push origin dev"
alias gpp="git pull && git push"
alias gl="git pull"
alias gf="git fetch --all"
alias gfp="git fetch --all --prune --verbose"

alias gu="git reset --soft HEAD^"
alias gr="git revert"

alias gs="git status -sb"
alias gcount="git shortlog -sn"
alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"

alias gexport="git archive --format zip --output"
