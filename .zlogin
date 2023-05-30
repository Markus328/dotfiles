source ~/.config/util/configure.sh
if [ "$(tty)" = "/dev/tty1" ] ; then
  export XDG_CURRENT_DESKTOP=sway
  exec sway
fi


