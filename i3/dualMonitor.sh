#!/bin/bash
extern=HDMI-1-0

if xrandr | grep "$extern connected"; then
	xrandr --output "$extern" --auto
fi
