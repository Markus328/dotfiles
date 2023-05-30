#!/usr/bin/env bash

success=false
type="png"
grim_init="grim -t $type"

args=("$@")
[ "${args[-1]}" = "copy" ] && image="/dev/stdout | wl-copy" || image=~/Imagens/print_$(date +%Y-%m-%d_%H-%m-%s).png

print_cmd=false
case "${args[0]}" in
area)
	select=$(slurp)
	if [[ "$select" ]]; then
		print_cmd="$grim_init -g \"$select\" $image"
	fi
	;;
window)

	swaymsg && window="-g "$(swaymsg -t get_tree | grep -EA 10 "\"focused\": true" | grep -E "\"(x|y|width|height)\": [0-9]+" | grep -Eo "[0-9]+" | tr '\n' ' ' | sed "s/^\([0-9]\+\) \([0-9]\+\)/\1,\2/g" | sed "s/ \([0-9]\+\) \([0-9]\+\) / \1x\2/g") || window=""
	if [[ "$window" ]]; then
		print_cmd="$grim_init $window $image"
	fi
	;;
*)
	swaymsg && focused_O="-o "$(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name') || focused_O=""
	print_cmd="$grim_init $focused_O $image"
	;;
esac

bash -c "$print_cmd" && success=true
$success && aplay ~/.config/util/sounds/screen_tick.wav
