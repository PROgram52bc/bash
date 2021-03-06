HOSTCOLLECTIONS="cse217{01..30}.cse.taylor.edu"
if [ $# -lt 1 ]; then
	echo "using default host collection string:"
else
	HOSTCOLLECTIONS="${1}"
	echo "using custom collection string:"
fi
echo "$HOSTCOLLECTIONS"

for host in $(eval echo $HOSTCOLLECTIONS); do
	host_name=${host#*@}
	echo "Trying to connect to $host:22..."
	if nc -w 1 $host_name 22 > /dev/null 2>&1; then # timeout 1 second
		# if successfully connected, quit and report
		echo "================$host is open!================"
		echo "Connecting with ssh..."
		exec ssh $host
	fi
done
