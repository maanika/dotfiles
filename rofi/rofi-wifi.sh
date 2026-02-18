#!/usr/bin/env bash

ROFI="rofi -dmenu -i -p WiFi"

main_menu() {
    echo -e "Connect\nDisconnect\nToggle WiFi"
}

connect_wifi() {
    networks=$(nmcli -t -f SSID,SECURITY,SIGNAL dev wifi list | grep -v "^--" | sort -u)

    chosen=$(echo "$networks" | $ROFI -p "Select Network")

    [ -z "$chosen" ] && exit

    ssid=$(echo "$chosen" | cut -d: -f1)

    security=$(echo "$chosen" | cut -d: -f2)

    if [[ "$security" == "--" || -z "$security" ]]; then
        nmcli dev wifi connect "$ssid"
        notify-send "WiFi" "Connected to $ssid"
    else
        password=$(rofi -dmenu -password -p "Password for $ssid")
        [ -z "$password" ] && exit
        nmcli dev wifi connect "$ssid" password "$password"
        notify-send "WiFi" "Connected to $ssid"
    fi
}

disconnect_wifi() {
    nmcli radio wifi off
    notify-send "WiFi" "WiFi Disabled"
}

toggle_wifi() {
    state=$(nmcli radio wifi)

    if [ "$state" = "enabled" ]; then
        nmcli radio wifi off
        notify-send "WiFi" "WiFi Disabled"
    else
        nmcli radio wifi on
        notify-send "WiFi" "WiFi Enabled"
    fi
}

choice=$(main_menu | $ROFI)

case "$choice" in
    "Connect")
        connect_wifi
        ;;
    "Disconnect")
        disconnect_wifi
        ;;
    "Toggle WiFi")
        toggle_wifi
        ;;
esac

