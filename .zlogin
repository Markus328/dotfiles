#!/bin/sh
source ~/.config/util/configure.sh
if [ "$(tty)" = "/dev/tty1" ] ; then
hikari &

elif [ "$(tty)" = "/dev/tty2" ] ; then
/bin/startx &

elif [ "$(tty)" = "/dev/tty3" ] ; then
/bin/sway &
fi


