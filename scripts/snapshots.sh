#!/usr/bin/env bash

subvol=$(btrfs su show / | awk '/Name:/ {print $NR}')

if [ "$subvol" != "@" ]; then
	valid=false
fi

name=""
ro="true"

homedir=/home/
rootdir=/

make_home=true
make_root=true
bind_home=false

while getopts "wrhbfn:" option; do
	case $option in
	f)
		valid=true
		;;
	n)
		name="$OPTARG"
		;;
	b)
		$make_home || bind_home=true
		;;
	h)
		make_home=false
		;;
	r)
		make_root=false
		;;
	w)
		ro="false"
		;;
	\?)
		echo "invalid option. exiting..."
		exit
		;;
	esac
done

if ! $valid; then
	echo "/ is not a real use subvolume, ignoring..."
	exit 1
fi

do_snapshot() {

	target="$1"
	dest=$target".snapshots"

	if [[ "$name" ]]; then
		new_snap=$dest/$name
	else
		snaps=($(ls "$dest" | grep -E '^[0-9]+$'))
		new_snap=$dest/"1"

		if [ -n "$snaps" ]; then

			last_snap=$(echo "${snaps[${#snaps[@]} - 1]}" | cut -c1)

			if [ "$last_snap" -ge 3 ]; then

				act_snap=$last_snap

				btrfs su del "$dest"/"${snaps[0]}" >/dev/null 2>&1

				for i in $(seq 1 $((${#snaps[@]} - 1))); do

					snap=${snaps[i]}

					n_snap=$(echo "$snap" | cut -c1)

					((n_snap--))

					mv "${dest}"/"${snap}" "${dest}"/${n_snap}

				done

			else
				act_snap=$((last_snap + 1))

			fi

			new_snap=$dest/$act_snap

		fi

	fi

	echo "$new_snap"
	btrfs su snap "$target" "$new_snap" >/dev/null
	return $?

}

snap_home=""
snap_root=""

do_home_snapshot() {

	if snap_home=$(do_snapshot "$homedir"); then
		echo "done home snapshot: $snap_home"
	else
		echo "failed to snapshot home: $snap_home"
		exit 1
	fi

}

do_root_snapshot() {
	if snap_root=$(do_snapshot "$rootdir"); then
		echo "done root snapshot: $snap_root"
	else
		echo "failed to snapshot root: $snap_root"
		exit 1
	fi

	if [[ "$snap_home" || $bind_home ]]; then
    local bound_home
		[[ "$snap_home" ]] && bound_home="$snap_home" || bound_home="$homedir"

		bound_home_id=$(btrfs su show "$bound_home" | awk '/Subvolume ID/ {print $NF}')
		home_subvol=$(btrfs su show "$homedir" | awk 'NR==1')
    home_id=$(btrfs su show "$homedir" | awk '/Subvolume ID/ {print $NF}')

    sed -i "s:\(subvol=/\?${home_subvol}\)\|\(subvolid=${home_id}\):subvolid=${bound_home_id}:g" "$snap_root"/etc/fstab
		echo "linked home snapshot to root snapshot /etc/fstab"

	fi
}

post_fixes() {
	[[ "$ro" == "true" ]] && echo "making snapshots read-only" || echo "making snapshots read-write"
	[[ "$snap_root" ]] && btrfs property set "$snap_root" ro $ro
	[[ "$snap_home" ]] && btrfs property set "$snap_home" ro $ro

}

$make_home && do_home_snapshot
$make_root && do_root_snapshot
post_fixes

echo "All done!"
