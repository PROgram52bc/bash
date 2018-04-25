#/bin/bash
# This script automatically mount Linux_Backup disk and back up files in ~/Document directory, then it unmount the directory. It is recommended to run this script periodically.
mountPath="/media/Linux_Backup"
backupFile="backup.sh"
devNum="/dev/sda7"

echo 
echo '**********************************'
echo "Backup output on $(date +"%x %X"):"

if [ ! -d "$mountPath" ]; then
    #sudo
    mkdir /media/Linux_Backup
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
if [ -f "$backupFile" ]; then
    #sudo 
    ./$backupFile && echo "Back-up complete!"
else
    echo "No back-up file: \"$backupFile\" found."
fi
cd ..

#sudo
/bin/umount $mountPath && 
echo "Device successfully unmounted at $(date +"%H:%M:%S")" &&
export DISPLAY=:0.0 && su wallet -c 'notify-send "Automatic Back-up" "Back-up Complete at $(date +"%H:%M:%S")" -i /home/wallet/Pictures/source/backup_icon.png' || 
echo "Cannot unmount the device."
