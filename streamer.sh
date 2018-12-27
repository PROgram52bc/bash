# width of the screen
width=$(tput cols)

# default values
fillChar='='
streamer="singleStreamer" 

usage() {
	echo "Print a line as a fancy streamer"
	echo "Usage: ./streamer.sh [-t|--triple] [{-p|-c|--padding} paddingCharacter] 'message'"
	exit 1;
}
repeat() {
	# usage: repeat 'char' 4
	# > charcharcharchar
	for (( i=0; i<$2; i++ )); do printf $1; done
}
singleStreamer() {
	# Assuming there is 1+ argument
	argLength=${#1}
	sideLength=$(( (width-argLength) / 2 ))
	repeat $fillChar $sideLength
	printf -- $1
	repeat $fillChar $sideLength
	printf "\n"
}

tripleStreamer() {
	# Assuming there is 1+ argument
	repeat $fillChar $width
	printf "\n"
	singleStreamer $1
	repeat $fillChar $width
	printf "\n"
}

# Process option arguments
while (( $# > 1 )); do 
	key="$1"
	case $key in
		-t|--triple)
			streamer="tripleStreamer"
			shift
			;;
		-s|--single) # default
			shift
			;;
		-c|-p|--padding) # padding
			fillChar=$2
			shift
			shift
			;;
		-*|--*) # unknown options
			echo "unknown option: $key"
			exit -1
			;;
	esac
done

if (( ${#@} < 1 )); then # if no message specified
	echo "You should specify a message to be printed"
	usage
fi

$streamer $1
