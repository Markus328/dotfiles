#!/usr/bin/env bash

subvol=`btrfs su show / | awk '/Name:/ {print $NR}'`

if [ "$subvol" != "@" ] ; then
	echo "/ is not a real use subvol, ignoring..."
	exit 1
fi

name=""
ro="true"

make_home=true
make_root=true


while getopts "wrhn:" option; do
  case $option in
    r)
      make_root=false;;
    h)
      make_home=false;;
    n)
      name="$OPTARG";;
    w)
      ro="false";;
    \?)
      echo "invalid option. exiting..."
      exit;;
  esac
done


do_snapshot(){

	target="$1"
	dest=$target".snapshots"

	if [[ "$name" ]] ; then
		new_snap=$dest/$name
	else
		snaps=(`ls $dest | grep -E '^[0-9]+$'`)
		new_snap=$dest/"1"

		if [ -n "$snaps"  ] ; then

			last_snap=`echo ${snaps[${#snaps[@]}-1]}  | cut -c1`

			if [ $last_snap -ge 3 ] ; then

				act_snap=$last_snap

				btrfs su del $dest/${snaps[0]} >/dev/null 2>&1

				for i in `seq 1 $((${#snaps[@]}-1))`; do

					snap=${snaps[i]}

					n_snap=`echo $snap | cut -c1`

					((n_snap--))

					mv ${dest}/${snap} ${dest}/${n_snap}

				done

			else
				act_snap=$((last_snap+1))

			fi

			new_snap=$dest/$act_snap


		fi

	fi

	echo $new_snap
	btrfs su snap  "$target" "$new_snap" >/dev/null 
	return $?

}

snap_home=""
snap_root=""


do_home_snapshot() {

if snap_home=`do_snapshot /home/`; then 
	echo "done home snapshot"
else
	echo "failed to snapshot home"
	exit 1
fi

}

do_root_snapshot(){
if snap_root=`do_snapshot /`; then 
	echo "done root snapshot"
else
	echo "failed to snapshot root"
	exit 1
fi

if [[ "$snap_home" ]] ; then
snap_home_id=`btrfs su show "$snap_home" | awk '/Subvolume ID/ {print $NF}'`
home_subvol=`btrfs su show /home | awk 'NR==1'`

sed -i "s:subvol=/\?${home_subvol}:subvolid=${snap_home_id}:g" "$snap_root"/etc/fstab
echo "linked home snapshot to root snapshot /etc/fstab"

fi
}

post_fixes(){
  [[ "$ro" == "true" ]] && echo "making snapshots read-only" || echo "making snapshots read-write"
  [[ "$snap_root" ]] && btrfs property set "$snap_root" ro $ro
  [[ "$snap_home" ]] && btrfs property set "$snap_home" ro $ro

}

$make_home && do_home_snapshot
$make_root && do_root_snapshot
post_fixes

echo "All done!"
