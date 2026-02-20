#!/usr/bin/env bash

# Detect connected monitors
laptop="eDP-1"
hdmi="HDMI-1"

if xrandr | grep -q "^$hdmi connected"; then
    # HDMI connected: set as primary, optionally mirror or extend
    xrandr --output $hdmi --auto --primary --output $laptop --off
else
    # HDMI not connected: use laptop screen
    xrandr --output $laptop --auto --primary --output $hdmi --off
fi

