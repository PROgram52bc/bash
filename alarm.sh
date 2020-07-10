#!/bin/bash
# The wav file to play in loop
SOUND_FILE="/home/wallet/Music/source/Electrical_Sweep-Sweeper-1760111493.wav"
# Maximum time for the alarm to last
MAX_SEC=60
PID="INIT"

cleanup() {
	# kill both the loop and its children (aplay)
	[ "$PID" != "INIT" ] && kill -9 $PID $(ps --ppid $PID --no-heading -o pid) 
	exit 0
}

trap cleanup SIGINT

while :; do aplay -q $SOUND_FILE ; done &
PID=$!
read -t $MAX_SEC -s -r -n 1 -p "Press any button to stop the alarm..." 
echo

cleanup


