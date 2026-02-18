#!/usr/bin/env bash

ROFI="rofi -dmenu -i -p Bluetooth"

bluetoothctl power on >/dev/null 2>&1

main_menu() {
    echo -e "Scan & Connect\nPaired devices\nConnected devices\nToggle Bluetooth"
}

scan_and_connect() {
    notify-send "Bluetooth" "Scanning for devices (5 seconds)..."
    bluetoothctl --timeout 5 scan on >/dev/null 2>&1

    devices=$(bluetoothctl devices)

    chosen=$(echo "$devices" | $ROFI -p "Connect to device")

    [ -z "$chosen" ] && exit

    mac=$(echo "$chosen" | awk '{print $2}')

    bluetoothctl trust "$mac" >/dev/null
    bluetoothctl pair "$mac" >/dev/null
    bluetoothctl connect "$mac" >/dev/null

    notify-send "Bluetooth" "Connected to $chosen"
}

paired_devices() {
    devices=$(bluetoothctl paired-devices)

    [ -z "$devices" ] && notify-send "Bluetooth" "No paired devices" && exit

    chosen=$(echo "$devices" | $ROFI -p "Connect paired device")

    [ -z "$chosen" ] && exit

    mac=$(echo "$chosen" | awk '{print $2}')

    bluetoothctl connect "$mac" >/dev/null

    notify-send "Bluetooth" "Connected to $chosen"
}

connected_devices() {
    devices=$(bluetoothctl devices | while read -r line; do
        mac=$(echo "$line" | awk '{print $2}')
        if bluetoothctl info "$mac" | grep -q "Connected: yes"; then
            echo "$line"
        fi
    done)

    [ -z "$devices" ] && notify-send "Bluetooth" "No connected devices" && exit

    chosen=$(echo "$devices" | $ROFI -p "Disconnect device")

    [ -z "$chosen" ] && exit

    mac=$(echo "$chosen" | awk '{print $2}')

    bluetoothctl disconnect "$mac" >/dev/null

    notify-send "Bluetooth" "Disconnected $chosen"
}

toggle_bt() {
    state=$(bluetoothctl show | grep "Powered:" | awk '{print $2}')

    if [ "$state" = "yes" ]; then
        bluetoothctl power off
        notify-send "Bluetooth" "Powered Off"
    else
        bluetoothctl power on
        notify-send "Bluetooth" "Powered On"
    fi
}

choice=$(main_menu | $ROFI)

case "$choice" in
    "Scan & Connect")
        scan_and_connect
        ;;
    "Paired devices")
        paired_devices
        ;;
    "Connected devices")
        connected_devices
        ;;
    "Toggle Bluetooth")
        toggle_bt
        ;;
esac

