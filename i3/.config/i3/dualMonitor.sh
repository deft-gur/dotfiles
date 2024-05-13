#!/bin/sh
# see https://wiki.archlinux.org/title/xrandr
intern=eDP
extern=DisplayPort-0

if xrandr | grep "$extern disconnected"; then
    #xrandr --output "$extern" --off --output "$intern" --auto
    xrandr --output "$extern" --off --output "$intern" --auto --scale 0.7
else
    xrandr --output "$intern" --off --output "$extern" --auto --scale 0.7
fi
