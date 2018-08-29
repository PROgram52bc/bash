#/bin/bash
# This script finds the real path of a symbolic link.
# Only the first argument is taken
# If there is no argument, then the script will take the current directory $PWD as the argument
# If the argument passed is a directory, then the script will open this directory in the file browser; if the argument passed is a file(non-directory), then the script will open the folder containing this file.
# If the argument is not a symbolic link, then the script will exit.
if [[ $1 == '.' ]] || [[ $1 == '' ]] # if the argument is . or there is no argument
    then dir=$(readlink -n $PWD) # Exchange "." into $PWD for 'readlink' to receive properly
else dir=$(readlink -n ${1%/}) # delete the final "/"
fi 
if [[ $dir == '' ]]; then
    echo "the input is not a symbolic link."
    exit 1 
else
path=${dir%/*}
file=${dir##*/} # Store information
    if [ -d $dir ]; # if it is a directory
    then
        cd "$dir"
        nautilus . &> /dev/null
        echo "$dir"
        echo "is opened in a new window"
    else # if it is a file
        cd "$path"
        nautilus . &> /dev/null
        echo "$path is the real path for"
        echo "$file" 
    fi
fi
