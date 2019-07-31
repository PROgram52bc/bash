#!/bin/bash
DIR=.
if [ $# -gt 1 ]; then
	echo "Usage: $0 [rootdir]"
	echo prints a list of files ending in .swp
	exit -1
elif [ $# -eq 1 ]; then
	if [ ! -d $1 ]; then
		echo "$1 is not a valid directory"
		exit -2
	fi
	DIR=$1
fi
find $DIR -name "*.swp" -print | sed 's/\.swp$//g' | sed 's%/\.\([^/]*\)$%/\1%g' | xargs -d "\n" -r -o vim -p
