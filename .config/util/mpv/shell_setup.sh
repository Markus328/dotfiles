yplay() {

	mpv  --ytdl-format=bestaudio ytdl://ytsearch:"$*"

}
ywatch(){

	mpv ytdl://ytsearch:"$*"

}
gdrivewatch() {

	mpv $1 --ytdl-raw-options=cookies=$HOME/mpv/cookies.txt,format=mp4

}

mwatch() {
	info="$*"
	url=`egrep "^(https|http)://[^ ]+$" <<< "$info"`
	if [[ "$url" ]] ; then 
	
		if 	[  `egrep "drive.google.com" <<< "$info"` ] ; then 
			gdrivewatch $info
		else 
			mpv $info
		fi
	else
		ywatch $info
	fi
} 
