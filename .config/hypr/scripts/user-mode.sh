#!/bin/bash

# Run the program and capture the output
output=$(mcontrolcenter -M NEXT)

# Extract the mode value
mode=$(echo "$output" | awk '{print $5}')

case "$mode" in
    "performance")
        icon="battery-profile-performance-symbolic"
        ;;
    "balanced")
        icon="battery-profile-balanced-symbolic"
        ;;
    "super") #super battery
        icon="battery-profile-powersave-symbolic"
        ;;
    "silent")
        icon="battery-profile-powersave-symbolic"
        ;;
    *)
        icon="battery-profile-powersave-symbolic"
        ;;
esac

# Send the output to notify-send
notify-send "Changing user mode" "$output" -i "$icon"

# Check if the output contains the word "performance"
if echo "$output" | grep -q "performance"; then
    # If "performance" is found, run "mcontrolcenter -B ON" and notify
    mcontrolcenter -B ON
else
    # Otherwise, run "mcontrolcenter -B OFF" and notify
    mcontrolcenter -B OFF
fi

