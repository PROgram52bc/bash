#!/bin/bash

##################
#  extract_date  #
##################

function extract_date {
	# usage: extract_date "datestring" var
	# returns 0 and sets var to the extracted date if succeeds
	# returns 1 if failed
	pattern1='[[:digit:]]{8}_[[:digit:]]{6}'
	pattern2='[[:digit:]]{13}'
	if echo $1 | grep -E $pattern1 > /dev/null; then
		# IMG_20210608_104811.jpg -> 2021-06-08 10:48:11
		value=`echo $1 | sed -E 's/.*([[:digit:]]{4})([[:digit:]]{2})([[:digit:]]{2})_([[:digit:]]{2})([[:digit:]]{2})([[:digit:]]{2}).*/\1-\2-\3 \4:\5:\6/'`
		eval $2='$value' # use quote to escape space in $value
	elif echo $1 | grep -E $pattern2 > /dev/null; then
		# mmexport1479161974377.jpg -> 2016-11-14 17:19:34-05:00
		epoch=`echo $1 | sed -E 's/.*([[:digit:]]{10})[[:digit:]]{3}.*/\1/'`
		eval $2='`date --date="@$epoch" --utc "+%Y-%m-%d %H:%M:%S"`'
	else
		return 1
	fi
}

function demo_extract_date {
	file_name=$1
	extract_date $file_name d
	if [ $? = 0 ]; then
		echo "Date: $d"
	else
		echo "No date extracted"
	fi
}

# demo_extract_date "mmexport1479161974377.jpg"
# demo_extract_date "IMG_20210608_104811_copy_1773x3840.jpg"
# demo_extract_date "invalid date"

##########
#  main  #
##########

if [ $# = 0 ]; then
	echo "No files specified"
	exit 0
fi

ASK=0 # ask by default

for file in $@; do
	echo "----------- $file -----------"

	if exiftool -q -if '$DateTimeOriginal' -dummyTag $file; then
		new_date_time=`exiftool -p '$DateTimeOriginal' -d '%Y-%m-%d %H:%M:%S' $file`
		echo "DateTimeOriginal detected: [$new_date_time]"
	elif exiftool -q -if '$CreateDate' -dummyTag $file; then
		new_date_time=`exiftool -p '$CreateDate' -d '%Y-%m-%d %H:%M:%S' $file`
		echo "CreateDate detected: [$new_date_time]"
	elif extract_date $file new_date_time; then
		echo "Date extracted from filename: [$new_date_time]"
	else
		read -N1 -p "No valid date found, enter manually? (Y/N)" response
		case $response in
			Y|y)
				read -p "Enter a datestring [yyyy-mm-dd hh:mm:ss] => " new_date_time
				;;
			*)
				echo "SKIP $file"
				continue
				;;
		esac
	fi

	old_date_time=`exiftool -p '$FileModifyDate' -d '%Y-%m-%d %H:%M:%S' $file`
	if [ "$old_date_time" = "$new_date_time" ]; then
		echo "No need to fix: [$new_date_time]"
		continue
	fi

	if [ $ASK = 0 ]; then
		read -N1 -p "Set modification date to [$new_date_time]? (Y/N/A/Q)" response
		echo
	else
		response="y"
	fi
	case $response in
		Y|y)
			;;
		A|a)
			ASK=-1
			;;
		Q|q)
			echo "ABORT"
			exit 0
			;;
		N|n|*)
			echo "SKIP $file"
			continue
			;;
	esac
	echo "Setting new modification date..."
	echo "[$old_date_time] => [$new_date_time]"
	exiftool -FileModifyDate="$new_date_time" "$file"
done
