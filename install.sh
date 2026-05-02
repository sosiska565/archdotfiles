#!/bin/bash

if ! command -v yay &> /dev/null; then
    git clone https://aur.archlinux.org/yay-bin.git
    cd yay
    makepkg -si
    cd ..
fi

yay -S --needed - < pkg_list.txt
yay -S --needed - < aur_list.txt

sudo pacman -S stow
cd ~/dotfiles
stow .
