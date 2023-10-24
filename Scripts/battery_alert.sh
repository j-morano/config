#!/bin/bash

while true
do
    battery_level=`cat /sys/class/power_supply/BAT0/capacity`
    battery_status=`cat /sys/class/power_supply/BAT0/status`
    if [ $battery_level -le 20 ] && [ $battery_status != "Charging" ]
    then
        notify-send -u critical "Battery low" "Battery level is ${battery_level}%!"
    fi
    sleep 120
done
