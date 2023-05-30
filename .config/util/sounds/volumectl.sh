#!/usr/bin/env bash

operation=$1
arg=$2

case "$operation" in
init)

	WOBSOCK=$XDG_RUNTIME_DIR/wob.sock
  killall wob
	rm -rf "$WOBSOCK"
	mkfifo "$WOBSOCK"
	tail "$WOBSOCK" -f | wob

	;;
up)
  pamixer -i "$arg"
	pamixer --get-volume > "$WOBSOCK"
	;;
down)
  pamixer -d "$arg"
	pamixer --get-volume > "$WOBSOCK"
	;;
esac
