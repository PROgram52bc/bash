#/bin/bash
# This scripts emits the "Link to " in the filenames of symbolic links in the current directory (or a specified directory using argument).
if [ $# -eq 0 ]; then
    directory=$PWD
else
    directory=$1
fi

find $directory -maxdepth 1 -type l -iname "link\ to\ *" -print0 | xargs -0 -n 1 rename -v -e 's/link to //i'
