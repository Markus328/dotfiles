#!/bin/bash

config=~/.config/hikari/hikari.conf
if `grep -q '1440x900@59.887' $config`; then
sed -i 's/1440x900@59.887/1280x720@60/' $config 
elif `grep -q '1280x720@60' $config`; then
	sed -i 's/1280x720@60/720x400@70.082001/' $config 
elif `grep -q '720x400@70.082001' $config`; then
	sed -i 's/720x400@70.082001/1440x900@59.887/' $config 
fi
