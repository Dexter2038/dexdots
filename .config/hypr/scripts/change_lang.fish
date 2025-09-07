#!/usr/bin/fish
set -l keyboard_name (hyprctl devices -j | jq ".keyboards | .[] | select(.main==true) | .name" | string replace -a '"' '')

hyprctl switchxkblayout $keyboard_name next
