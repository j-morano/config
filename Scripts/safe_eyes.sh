#!/bin/bash

while true
do
    sleep 3600
    notify-send -t 60000 -u critical \
        "Safe eyes"\
        "Take your eyes off the screen for a minute!\nLook at something far away for a few seconds."
done
