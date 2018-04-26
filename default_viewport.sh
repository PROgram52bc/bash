#/bin/bash
# This script switches the current viewport to the central one
# note: This doesn't work if another screen is plugged,
# As a solution, don't plug-in external screen until the script is loaded!
##debug lines start with ##
##touch ~/Desktop/debug.log
##
##until pgrep "Xorg" > /dev/null && pgrep "compiz" > /dev/null
##do
##	echo "$(date)\tNot yet ready" >> ~/Desktop/debug.log
##    sleep 1
##done
##
# until current workspace is switched
until [ $(wmctrl -d | awk '{print $6}') = "1920,1080" ]
do
	sleep 1
	wmctrl -o 1920,1080
##	echo "$(date)\tTrying to switch viewport.." >> ~/Desktop/debug.log
##	echo "Current viewport: $(wmctrl -d | awk '{print $6}')" >> ~/Desktop/debug.log
##  	if [ $(wmctrl -d | awk '{print $6}') = "1920,1080" ]
##	then 
##		echo "String equal" >> ~/Desktop/debug.log
##	else
##		echo "String not equal" >> ~/Desktop/debug.log
##		echo "String 1: $(wmctrl -d | awk '{print $6}')" >> ~/Desktop/debug.log
##		echo "String 2: 1920,1080" >> ~/Desktop/debug.log
##	fi
done
##echo "$(date)\tviewport Switched." >> ~/Desktop/debug.log
