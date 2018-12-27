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
	# Storing all arguments as a single string
	argString=$*
	argLength=${#argString}
	sideLength=$(( (width-argLength) / 2 ))
	repeat $fillChar $sideLength
	printf -- "${argString}"
	repeat $fillChar $sideLength
	printf "\n"
}

tripleStreamer() {
	repeat $fillChar $width
	printf "\n"
	singleStreamer "$*"
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
# Not using, since user might want to print sth like '--hello'
#		-*|--*) # unknown options
#			echo "unknown option: $key"
#			exit -1
#			;;
		*)
			break
			;;
	esac
done

if (( ${#@} < 1 )); then # if no message specified
	echo "You should specify a message to be printed"
	usage
fi

$streamer $*
