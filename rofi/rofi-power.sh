#!/usr/bin/env bash

ROFI="rofi -dmenu -i -p Power"

options="Shutdown\nReboot\nLogout\nLock\nSuspend"

chosen=$(echo -e "$options" | $ROFI)

case "$chosen" in
    Shutdown)
        systemctl poweroff
        ;;
    Reboot)
        systemctl reboot
        ;;
    Logout)
        i3-msg exit
        ;;
    Lock)
        ~/.config/rofi/lock.sh
        ;;
    Suspend)
        systemctl suspend
        ;;
esac

