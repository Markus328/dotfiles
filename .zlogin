source ~/.config/util/configure.sh
if [ "$(tty)" = "/dev/tty1" ] ; then
exec startplasma-wayland
fi


