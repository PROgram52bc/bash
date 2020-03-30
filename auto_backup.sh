#!/bin/bash
# This script automatically mount Linux_Backup disk and back up files in ~/Document directory, then it unmount the directory. It is recommended to run this script periodically.
mountPath="/media/Linux_Backup"
backupScript="backup.sh"
devNum="/dev/sda7"
backupLog="/var/log/cron/auto_backup.log"
backupLogMaxSize=10000 # 100 kb

function trim_log {
	if [ -f "$backupLog" ]; then
		backupLogSize=$(stat -c %s "$backupLog")
		if (( backupLogSize > backupLogMaxSize )); then
			newBackupLog=$(mktemp "${backupLog}.XXX")
			{ 
				echo "...above $(( backupLogSize-backupLogMaxSize )) bytes trimmed at $(date +"%x %X")";
				tail -c $backupLogMaxSize $backupLog; 
			} > $newBackupLog
			mv "$newBackupLog" "$backupLog"
		fi
	fi
}

function backup {
	echo 
	echo '**********************************'
	echo "Backup output on $(date +"%x %X"):"

	if [ ! -d "$mountPath" ]; then
		#sudo
		mkdir "$mountPath"
	fi

	isMounted=$(/bin/mount -l | grep "$devNum")
	if [ "$isMounted" ]; then
		echo "Device $devNum is already mounted, now remounting it to $mountPath..."
		#sudo
		/bin/umount $devNum || exit -1
	fi

	#sudo
	/bin/mount $devNum $mountPath &&
		echo "Successfully mounted to ${mountPath}!" || exit -1

	cd $mountPath
	if [ -f "$backupScript" ]; then
		#sudo 
		./$backupScript 2>&1 && echo "Back-up complete!"
	else
		echo "No back-up script: \"$backupScript\" found."
	fi
	cd ..

	#sudo
	/bin/umount $mountPath && 
		echo "Device successfully unmounted at $(date +"%H:%M:%S")" &&
		export DISPLAY=:0.0 && su wallet -c 'notify-send "Automatic Back-up" "Back-up Complete at $(date +"%H:%M:%S")" -i /home/wallet/Pictures/source/backup_icon.png' || 
		echo "Cannot unmount the device."
}

trim_log
backup >> $backupLog
