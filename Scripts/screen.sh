#!/bin/sh

if [ "$1" = "extend" ]
then
    xrandr --output eDP-1 --primary --auto --output HDMI-2 --pos 1366x0 --auto
elif [ "$1" = "laptop-only" ]
then
    xrandr --output eDP-1 --primary --auto --output HDMI-2 --off
fi