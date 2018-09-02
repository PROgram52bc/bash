#!/bin/bash
# This is an improved version of the previous transfer.sh, which can 
# 1. handle space in file names correctly, 
# 2. skip files being downloaded (files that match DownloadingRegex)
# 3. retry automatically after a few seconds
DownloadDIR=${HOME}/Downloads
DownloadingRegex="^.*\.part$"
RetryCountDown=10

transfer()
{
	DownloadingIdx=0
	DownloadedIdx=0
	# Declare 2 arrays
	declare -a downloadingFiles # Stores all 'a' and 'a.part' files as 'a'
	declare -a downloadedFiles # Stores all files 'a' without a corresponding 'a.part'
	for file in $DownloadDIR/*
	do
		if [ ! -f "$file" ]; then continue; fi # skip all non-files. e.g. ~/Downloads/*
		if [[ $file =~ $DownloadingRegex ]]; then continue; fi # skip all files in the form 'a.part'
		if [ -f "${file}.part" ]; then # if file is being downloaded
			downloadingFiles[$DownloadingIdx]=${file} 
			((DownloadingIdx++))
		else
			downloadedFiles[$DownloadedIdx]=${file}
			((DownloadedIdx++))
		fi
	done

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

transfer

