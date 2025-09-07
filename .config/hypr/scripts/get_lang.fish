#!/usr/bin/fish
set -l lang (hyprctl devices -j | jq ".keyboards | .[] | select(.main==true) | .active_keymap")

if echo $lang | grep -q -i ru
    set short_lang ru
else
    set short_lang en
end

echo "{\"lang\": \"$short_lang\"}"
