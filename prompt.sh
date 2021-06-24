#!/bin/bash
# sends a prompt using 'notify-send' and optionally play sound using 'bell.sh'
help() {
	echo "Display a notification with a bell sound"
	echo "Usage: ${0##*/} -[sh] message [submessage]"
	echo "-h: display this help"
	echo "-s: does not play sound"
}

RING_BELL=true
# parse arguments
while getopts 'sh' c; do
	case $c in
		s) RING_BELL=false ;;
		h) help
	esac
done
# get rid of arguments parsed by getopts
shift $((OPTIND-1))

if [ $# -eq 0 ]; then
	echo "No message to display. Abort"
	exit -1
else
	notify-send -i appointment-soon "${@:1:2}"
	if [ "$RING_BELL" = true ]; then bell.sh; fi
fi
