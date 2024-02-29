export QT_QPA_PLATFORMTHEME=qt5ct
export MOZ_ENABLE_WAYLAND=1

## Wayland XKB layouyt
export XKB_DEFAULT_OPTIONS="ctrl:nocaps"
export XKB_DEFAULT_LAYOUT="workman"
export XKB_DEFAULT_VARIANT=""

# eval $(ssh-agent)

## Wob and volume control
# export WOBSOCK="$XDG_RUNTIME_DIR/wob.sock"

# export CREATE_WOB="sh -c \"rm -f $WOBSOCK && mkfifo $WOBSOCK && tail $WOBSOCK -f | wob -H 50 -a bottom &\""

# export VOLTEST="pamixer --get-volume > $WOBSOCK"
# export VOLINC="pamixer -i"
# export VOLDEC="pamixer -d"


## Mpv scripts
source ~/.config/util/mpv/shell_setup.sh
