#!/bin/bash

# Get the current layout
CURRENT_LAYOUT=$(hyprctl devices | grep -A 2 "at-translated-set-2-keyboard" | grep "active keymap" | awk '{print $3}')

# Switch layout
hyprctl switchxkblayout "at-translated-set-2-keyboard" next

# Determine the new layout
NEW_LAYOUT=$(hyprctl devices | grep -A 2 "at-translated-set-2-keyboard" | grep "active keymap" | awk '{print $3}')

# Set the icon based on the new layout
if [ "$NEW_LAYOUT" == "Russian" ]; then
    ICON="indicator-keyboard-Ru"
else
    ICON="indicator-keyboard-En"
fi

# Send notification
notify-send -i "$ICON" "Keyboard Layout Switched" "Current layout: $NEW_LAYOUT"

