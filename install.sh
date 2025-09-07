#!/usr/bin/bash
if command -v fish >/dev/null 2>$1; then
    echo "Fish is installed"
else
    echo "Fish is not installed"
    sudo pacman -S fish --noconfirm
fi

fish install.fish
