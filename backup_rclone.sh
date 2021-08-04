#!/bin/bash

################################################################
#  This script backs up a folder to google drive using rclone  #
################################################################

SOURCE="/home/wallet/Documents/Obsidian/"
DESTINATION="google-drive:notes"

# switch the following two lines to ignore all hidden files/folders

# rclone copy --exclude='.*' --exclude='.*/**' --update --transfers 30 --checkers 8 --contimeout 60s --timeout 300s --retries 3 --low-level-retries 10 --stats 1s ${SOURCE} ${DESTINATION}

rclone copy --exclude='.git' --exclude='.git/**' --update --transfers 30 --checkers 8 --contimeout 60s --timeout 300s --retries 3 --low-level-retries 10 --stats 1s ${SOURCE} ${DESTINATION}



code=$?
export DISPLAY=:0.0 
if [ $code -eq 0 ]; then
	# su wallet -c 
	/usr/bin/notify-send "Rclone Backup" "Back-up Complete at $(date +"%H:%M:%S"), from ${SOURCE} to ${DESTINATION}" -i /home/wallet/Pictures/source/backup_icon.png
else
	# su wallet -c 
	/usr/bin/notify-send "Rclone Backup" "Back-up failed with exit code ${code}, rerun $0 to debug" -i /home/wallet/Pictures/source/warning_yellow.png
fi
