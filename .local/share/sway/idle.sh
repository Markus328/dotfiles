#!/bin/bash
isPlaying(){
pacmd list-sink-inputs | egrep -q 'application\.name.+(Firefox|Google Chrome|Nightly)'
return $?
}
export -f isPlaying

swayidle -w timeout 300 "isPlaying || swaymsg 'output * dpms off'" resume "swaymsg 'output * dpms on'" timeout 900 "isPlaying || systemctl suspend" after-resume "swaymsg 'output * dpms on'"
