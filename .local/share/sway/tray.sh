#!/bin/bash


saved="/home/markus/Videos/marecord_$(date +%d-%m-%y--%H:%M)".mp4

trap "rm -f $saved && killall tray.py" 15

sudo -u  markus env XDG_RUNTIME_DIR=/run/user/1000 /home/markus/.config/sway/tray.py &


sudo /bin/marecord $saved

