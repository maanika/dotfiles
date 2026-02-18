#!/bin/bash

# Kill any existing polybar instances
killall -q polybar

# Path to config
CONFIG_FILE="$HOME/.config/polybar/config.ini"

if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
      MONITOR=$m polybar --reload -c "$CONFIG_FILE" toph &
  done
else
  polybar --reload example &
fi

