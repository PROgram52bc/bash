#!/bin/bash
# This program watches for processes that consume high cpu
# and notify, kill them as needed.
KILLLEVELCPU=95 # The percentage cpu usage to kill the process
NOTELEVELCPU=60 # The percentage cpu usage to notify the process
KILLLEVELMEM=95 # The percentage memory usage to kill the process
NOTELEVELMEM=60 # The percentage memory usage to notify the process
TIMEINTERVAL=30 # The interval between two checks, in seconds
NOTEICON="/home/wallet/Pictures/source/warning_yellow.png"
KILLICON="/home/wallet/Pictures/source/warning_shield.png"
## LOGFILE="/home/wallet/Desktop/cpu_watcher.log"


## echo $(date) >> $LOGFILE
## echo "Script ran" >> $LOGFILE

while :
do
## 	echo $(date) >> $LOGFILE
## 	echo "Checked once" >> $LOGFILE
	result=$(ps -eo pid,pcpu,pmem,comm --sort -pcpu | head -n 2 | tail -n 1)
	pid=$(echo $result | awk '{print $1}')
	cpu=$(echo $result | awk '{print $2}')
	mem=$(echo $result | awk '{print $3}')
	name=$(echo $result | awk '{$1=$2=$3=""; print substr($0,4)}')
	
	# checking cpu
	if [ ${cpu%%.*} -ge ${KILLLEVELCPU} ]
	then
		kill ${pid}
		notify-send -i ${KILLICON} "High CPU Process Killed" "${name} (pid: ${pid}) was using ${cpu}% of CPU."

	elif [ ${cpu%%.*} -ge ${NOTELEVELCPU} ]
	then
		notify-send -i ${NOTEICON} "CPU Usage Warning" "${name} (pid: ${pid}) is using ${cpu}% of CPU."
	fi

	# checking memory
	if [ ${mem%%.*} -ge ${KILLLEVELMEM} ]
	then
		kill ${pid}
		notify-send -i ${KILLICON} "High Memory Process Killed" "${name} (pid: ${pid}) was using ${mem}% of memory."

	elif [ ${mem%%.*} -ge ${NOTELEVELMEM} ]
	then
		notify-send -i ${NOTEICON} "Memory Usage Warning" "${name} (pid: ${pid}) is using ${mem}% of memory."
	fi

	sleep $TIMEINTERVAL
done
