#!/usr/bin/fish
set lang (hyprctl devices -j | jq ".keyboards | .[] | select(.main==true) | .active_keymap")

#if echo $lang | grep -q -i ru
#    set short_lang RU
#else
#    set short_lang EN
#end

echo "{\"lang\": $lang}"
