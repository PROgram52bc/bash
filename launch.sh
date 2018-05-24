#!/bin/bash
# This script check if the given program is already running
# if yes, exit
# if not, run the program
## LOGFILE="/home/wallet/Desktop/launch.log"
if [ "$#" -ne 1 ]; then
	echo "Usage: $0 PROGRAM_NAME"
	exit 1
fi

if [ "$(ps ax | grep -v grep | grep -v $0 | grep $1)" ]; then 
##	echo $(date) >> $LOGFILE
##	echo "Script not launched because already running" >> $LOGFILE
##	echo $(ps ax | grep -v grep | grep -v $0 | grep $1) >> $LOGFILE
	exit 0
else
	$1 &
## 	echo $(date) >> $LOGFILE
## 	echo "Script launched successfully" >> $LOGFILE
fi

