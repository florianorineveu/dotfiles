if [[ $(uname -a) == *"MANJRO"* ]]; then
    alias upgrade="sudo pacman -Syyu"
    alias add="sudo pacman -S"
    alias rem="sudo pacman -Rns"
    alias nuke="sudo pacman -Rncss"
    alias wtf="sudo pacman -Qi"
    alias look="sudo pacman -Qs"
    alias sys="sudo systemctl"
    alias svgtopng="for file in *.svg; do inkscape $file -e ${file%svg}png; done"
fi