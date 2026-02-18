#!/bin/bash

# Kill any existing polybar instances
killall -q polybar

# Path to config
CONFIG_FILE="$HOME/.config/polybar/config.ini"

# Check if xrandr exists
if type xrandr >/dev/null 2>&1; then
    # Loop over all connected monitors
    for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
        MONITOR=$m polybar --reload -c "$CONFIG_FILE" toph &
    done
else
    # Fallback: just launch one bar
    polybar --reload -c "$CONFIG_FILE" toph &
fi
