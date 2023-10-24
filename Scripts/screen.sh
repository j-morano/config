#!/bin/sh

if [ "$1" = "extend" ]
then
    xrandr --output eDP1 --primary --auto --output HDMI2 --pos 1366x0 --auto
    xset s off -dpms
elif [ "$1" = "laptop" ]
then
    xrandr --output eDP1 --primary --auto --output HDMI2 --off
    xset s on -dpms
elif [ "$1" = "external" ]
then
    xrandr --output eDP1 --off --output HDMI2 --primary --auto
    xset s off -dpms
fi
