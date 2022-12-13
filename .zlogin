#!/bin/sh
source ~/.config/util/configure.sh
if [ "$(tty)" = "/dev/tty1" ] ; then
startplasma-wayland
fi


