#!/bin/bash
# This script compresses images using the utility of ImageMagick. 
# One should use filenames as arguments. If no arguments are provided, then the script will automatically compress all .jpg files under current directory. 
# All files are named "Compressed_n.xxx", where n starts from 1, xxx is the extension of the file being compressed.
q=50
i=1
if [[ $# == 0 ]]; then
    for file in ./*.jpg; do convert -strip -interlace Plane -gaussian-blur 0.05 -quality $q% $file "Compressed_${i}.jpg"; 
        echo "Converting $file to Compressed_${i}.jpg";
        let i++;
    done
else
    for file in $@; do convert -strip -interlace Plane -gaussian-blur 0.05 -quality $q% $file "Compressed_${i}.${file##*.}";
        let i++;
    done
fi
