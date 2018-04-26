#/bin/bash
# This program watches for processes that consume high cpu
# and notify, kill them as needed.
# Note: The check-if-running at the beginning don't work for scripts running from terminals; but it does prevent multiple copies from running after log-out and log-in.

# START check-if-running
if [ "$(ps ax | grep -v grep | grep $0)" ]; then echo "Already running";exit; fi
# END check-if-running

KILLLEVEL=95 # The percentage to kill the process
NOTELEVEL=60 # The percentage to notify the process
TIMEINTERVAL=30 # The interval between two checks, in seconds
NOTEICON="/home/wallet/Pictures/source/warning_yellow.png"
KILLICON="/home/wallet/Pictures/source/warning_shield.png"

while :
do
	result=$(ps -eo pcpu,pid,comm --sort -pcpu | head -n 2 | tail -n 1)
	cpu=$(echo $result | awk '{print $1}')
	pid=$(echo $result | awk '{print $2}')
	name=$(echo $result | awk '{$1=$2=""; print substr($0,3)}')
	
	if [ ${cpu%%.*} -ge ${KILLLEVEL} ]
	then
		kill ${pid}
		notify-send -i ${KILLICON} "High CPU Process Killed" "${name} (pid: ${pid}) was using ${cpu}% of CPU."

	elif [ ${cpu%%.*} -ge ${NOTELEVEL} ]
	then
		notify-send -i ${NOTEICON} "CPU Usage Warning" "${name} (pid: ${pid}) is using ${cpu}% of CPU."
	fi

	sleep $TIMEINTERVAL
done
