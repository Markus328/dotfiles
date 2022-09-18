
allpids=~/.config/sway/info_pids.txt
pid=`swaymsg -t get_tree | jq '.nodes[].nodes[].nodes[] | select(.focused).pid'`
[[ "$pid" ]] || pid=`swaymsg -t get_tree | jq '.nodes[].nodes[].nodes[].nodes[] | select(.focused).pid'`
[ -f $allpids ] || touch $allpids
if ! `cat $allpids | egrep -q "$pid"` ; then
info="via %shell - pid $pid"
swaymsg title_format "$info"
echo "$pid" >> $allpids
else
swaymsg title_format "%title"
sed -i "/$pid/d" $allpids	
fi

