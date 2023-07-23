source ~/.config/util/configure.sh
tty="$(tty)"
if [ "$tty" = "/dev/tty1" ]; then
  exec Hyprland
elif [ "$tty" = "/dev/tty3" ]; then
  export XDG_CURRENT_DESKTOP=sway
  exec sway
fi


