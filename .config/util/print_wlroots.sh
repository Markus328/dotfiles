#!/usr/bin/env bash

success=false
args=($@)
[ "${args[-1]}" = "copy" ] && image="/tmp/wl_print.png ; wl-copy < /tmp/wl_print.png ; rm -f /tmp/wl_print.png" || image=~/Imagens/print_$(date +%Y-%m-%d_%H-%m-%s).png


grim_cmd=false
case "${args[0]}" in
area) 
    select=$(slurp)
    if [[ "$select" ]] ; then
	grim_cmd="grim -t png -g \"$select\" $image"
    fi
;;
window)
    
    window=`swaymsg -t get_tree | egrep -A 10 "\"focused\": true" | egrep "\"(x|y|width|height)\": [0-9]+" | egrep -o "[0-9]+" | tr '\n' ' ' |  sed "s/^\([0-9]\+\) \([0-9]\+\)/\1,\2/g" | sed "s/ \([0-9]\+\) \([0-9]\+\) / \1x\2/g"`
    if [[ "$window" ]] ; then
	grim_cmd="grim -t png -g \"$window\" $image"
    fi
;;
*) 
    grim_cmd="grim -t png $image"
;;
esac

bash -c "$grim_cmd" && success=true
$success && aplay ~/.config/sounds/screen_tick.wav


