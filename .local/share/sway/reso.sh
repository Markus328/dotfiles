reso=`swaymsg -t get_outputs | jq ".[].current_mode"`
reso="$(echo $reso | jq '.width')x$(echo $reso | jq '.height')"
case $reso in

800x600)
swaymsg "output * mode 1440x900@59.887Hz"
;;
1440x900)
[ "$1" == "75" ] && swaymsg "output * mode 800x600@75Hz" || swaymsg "output * mode 800x600@60.317Hz"
;;
*)
swaymsg "output * mode 1440x900@59.887Hz"
;;
esac

