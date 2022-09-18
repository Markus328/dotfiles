#!/bin/sh

Path=~/.config/sway/menu_apps


update_desk(){
IFS='
'
NAMES=""
content="declare -Ag APPS
"
for app in `find /usr/share/applications ~/.local/share/applications -name "*.desktop"`; do 
if ! `egrep -q "NoDisplay=true" $app`; then
name=`egrep -m 1 "Name=.+" "$app" | cut -d"=" -f2` 
NAMES+=":$name"
content+="APPS+=([\"$name\"]=\"$app\")
"
fi
done
content+="NAMES=\"$NAMES\""
echo "$content" > $Path
chmod +x $Path
}
[ -f $Path ] || update_desk
. $Path
gtk-launch `echo ${APPS["$(echo $NAMES | tr ':' '\n' | bemenu -i -p Aplicativos)"]} | egrep -o "[^/]+\.desktop$"
`
update_desk
