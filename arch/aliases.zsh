if [[ $(uname -a) == *"MANJRO"* ]] || [[ $(uname -a) == *"-arch1-"* ]]; then
    alias pacupgrade="sudo pacman -Syyu"
    alias pacadd="sudo pacman -S"
    alias pacrem="sudo pacman -Rns"
    alias pacnuke="sudo pacman -Rncss"
    alias pacwtf="sudo pacman -Qi"
    alias paclook="sudo pacman -Qs"
    alias sys="sudo systemctl"
    alias svgtopng="for file in *.svg; do inkscape $file -e ${file%svg}png; done"
fi