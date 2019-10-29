# OTHERS
##########
alias l="ls -lha"
alias fuck="fuck -y"
alias mkdir="mkdir -p"

# NAVIGATION
##########
alias ..="cd .."
alias ...="cd ../.."
alias www="cd /Volumes/BETA/Developpement"
alias nd="cd /Volumes/BETA/Developpement/NewDeal"
alias nda="cd /Volumes/BETA/Developpement/NewDeal/app"

# MANJARO
##########
alias cl="clear"
alias upgrade="sudo pacman -Syyu"
alias add="sudo pacman -S"
alias rem="sudo pacman -Rns"
alias nuke="sudo pacman -Rncss"
alias wtf="sudo pacman -Qi"
alias look="sudo pacman -Qs"
alias bloat="sudo pacman -Qtt"
alias deps="sudo pacman -Qtd"
alias sys="sudo systemctl"
alias check="sudo systemctl enable"
alias check="sudo systemctl enable --now"
alias check="sudo systemctl status"
alias svgtopng="for file in *.svg; do inkscape $file -e ${file%svg}png; done"
