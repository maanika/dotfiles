#!/bin/bash

tmpbg=/tmp/lockscreen.png

# Take screenshot
scrot $tmpbg

# Blur it
convert $tmpbg -blur 0x8 -brightness-contrast -10x-20 $tmpbg

# Lock with blurred background
i3lock -i $tmpbg -e

