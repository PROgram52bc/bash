#!/bin/bash
# This is an improved version of the previous transfer.sh, which can 
# 1. handle space in file names correctly, 
# 2. skip files being downloaded (files that match DownloadingRegex)
# 3. retry automatically after a few seconds

. match.sh --source-only

DownloadDir=${HOME}/Downloads
DownloadingRegex="^.*\.part$"
RetryCountDown=10
Override=false
MatchAll=true
MatchPattern=""

usage() { 
	echo "`basename $0` [-hf] [pattern]"; 
	echo -e "\ttransfers Downloaded files to current directory" 
	echo "-h: display this help and exit"
	echo "-f: override existing files"
	echo "pattern: patterns to be matched in downloaded files. (e.g. *.pdf)"
}

transfer()
{
	DownloadingIdx=0
	DownloadedIdx=0
	# Declare 2 arrays
	declare -a downloadingFiles # Stores all 'a' and 'a.part' files as 'a'
	declare -a downloadedFiles # Stores all files 'a' without a corresponding 'a.part'
	
	for file in $DownloadDir/*; do
		########################
		#  handle empty match  #
		########################
		if [ ! -f "$file" ] && [ ! -d "$file" ]; then continue; fi # skip all that are non-files and non-directories. e.g. ~/Downloads/*

		##########################
		#  handle guarded files  #
		##########################
		
		# TODO: Have abstraction to capture the semantic that:
		# if a.txt.part exists, then don't transfer a.txt 
		# rename it to something like "guardedfile" for things other than download (e.g. cache files)
		# <2022-06-07, David Deng> #
		if [[ $file =~ $DownloadingRegex ]]; then continue; fi # skip all files in the form 'a.part'
		if [ -f "${file}.part" ]; then # if file is being downloaded
			downloadingFiles[$DownloadingIdx]=${file} 
			((DownloadingIdx++))
			continue
		fi

		##########################
		#  handle match pattern  #
		##########################
		
		if ! $MatchAll && ! match "$MatchPattern" "$file" ]]; then
			echo "Skipping $file, not matching pattern $MatchPattern"
			continue
		fi

		#####################
		#  handle override  #
		#####################
		
		local base=${file##*/}
		if [ -f "$PWD/$base" ] || [ -d "$PWD/$base" ]; then
			if ! $Override; then
				echo "Skipping $file, already exists in $PWD, use -f to override"
				continue
			else
				echo "overriding existing file $file"
			fi
		fi
		downloadedFiles[$DownloadedIdx]=${file}
		((DownloadedIdx++))
	done

	################
	#  move files  #
	################

	if [ ${#downloadedFiles[@]} != 0 ]; then
		echo "${#downloadedFiles[@]} file(s) being moved to $PWD:"
		for i in "${downloadedFiles[@]}"
		do
			mv "$i" "$PWD" 
			echo "${i##*/}"
		done
		echo "Done!"
		echo
	fi

	# retry on files being downloaded
	if [ ${#downloadingFiles[@]} != 0 ]; then
		echo "${#downloadingFiles[@]} file(s) being downloaded, thus not moved:"
		for i in "${downloadingFiles[@]}"
		do
			echo "${i##*/}"
		done

		# count down and retry
		for (( i=$RetryCountDown; i>0; i-- ))
		do
			printf "Retry in $i... (press Ctrl-C to terminate)"
			sleep 1
			printf "\r                                          \r"
		done
		echo
		transfer
	fi
}

###########################
#  process cli arguments  #
###########################

while getopts ":hf" o; do
    case "${o}" in
        f)
			Override=true
            ;;
        h)
			usage
			exit 0
            ;;
        *)
			usage
			exit 1
    esac
done
shift $((OPTIND-1))

if [ $# -gt 0 ]; then 
	MatchPattern=$1
	MatchAll=false
fi
shift

if [ $# -gt 0 ]; then echo "extra arguments ignored: $@"; fi

transfer
