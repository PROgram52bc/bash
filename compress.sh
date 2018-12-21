#!/bin/bash
# This script compresses images using the utility of ImageMagick. 
# One should use filenames as arguments. If no arguments are provided, then the script will automatically compress all .jpg files under current directory. 
# All files are put into a subdirectory named with their original names
quality=50
i=1
shopt -s nullglob # set failed file expansion to null
directory="out"
files=( ${@:-*.jpg} )
echo ${#files[@]}
if (( ${#files[@]} == 0 )); then echo ERROR: no jpg files specified or in current directory for compression; exit -1; fi 
[ ! -d "$directory" ] && mkdir $directory;
for file in "${files[@]}"; do 
	if [ ! -f "${file}" ]; then echo "WARNING: ${file} does not exist, skipping to next"; continue; fi # skip files than do not exist
	if [ -f "${directory}/${file}" ]; then
		echo "file $file already exists in $directory, override it? (y/n)"	
		read -s -n 1 answer
		if [ "$answer" != 'y' ]; then echo "skipped $file"; continue; fi 
	fi
	echo "Converting $file to ${directory}/${file}";
	convert -strip -interlace Plane -gaussian-blur 0.05 -quality ${quality}% $file "${directory}/${file}";
done
echo done!
