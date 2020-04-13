# default
MNTDIR=~/Desktop/google-drive
OPERATION=MOUNT 

mount() {
	if [ ! -d "$MNTDIR" ]; then
		echo "Creating $MNTDIR..."
		mkdir -p "$MNTDIR" && echo "Done"
	fi
	if mountpoint "$MNTDIR" -q; then
		echo "$MNTDIR is already mounted"
		return -1
	fi
	echo "Mounting google drive to $MNTDIR..."
	if google-drive-ocamlfuse "$MNTDIR"; then
		echo "Successfully mounted google drive to $MNTDIR"
		echo "Opening new window..."
		xdg-open "$MNTDIR" && echo "Done"
	else
		echo "Failed to mount google drive"
	fi
}

unmount() {
	if [ ! -d "$MNTDIR" ]; then
		echo "$MNTDIR does not exist."
		return -1
	fi
	if ! mountpoint "$MNTDIR" -q; then
		echo "$MNTDIR is not currently mounted"
		return -1
	fi
	echo "Unmounting google drive to $MNTDIR..."
	if fusermount -u "$MNTDIR"; then
		echo "Successfully unmounted google drive from $MNTDIR"
		echo "Deleting $MNTDIR..."
		rmdir $MNTDIR && echo "Done"
	else
		echo "Failed to umount google drive"
	fi
}

help() {
	echo "Usage: ${0##*/} [-muh] MNTDIR"
	echo "-m: specify the operation to be 'mount', default operation"
	echo "-u: specify the operation to be 'unmount'"
	echo "-h: display this help"
	echo "MNTDIR: the directory to be moutned on; create if does not exist, delete after unmounting the drive."
}

# parse arguments
while getopts 'muh' c; do
	case $c in
		m)	OPERATION=MOUNT		;;
		u)	OPERATION=UNMOUNT	;;
		h)	help; exit 0 		;;
	esac
done
# get rid of arguments parsed by getopts
shift $((OPTIND-1))

# override default MNTDIR
if [ $# -ge 1 ]; then
	MNTDIR=$1
fi
# perform the specified operation
case $OPERATION in
	MOUNT)		mount	;;
	UNMOUNT)	unmount	;;
esac
