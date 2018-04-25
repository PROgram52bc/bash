#!/bin/bash
# This script creates symbolic links on the Desktop, with name(s) as same as that of the original file(s).  
function fulldir() {
    if [[ $1 =~ ^/ ]]; then # If the 1st argument contains /.* [regex] (is an absolute path)
        echo $1
    else # If the 1st argument is not an absolute path
        if [[ $1 =~ / ]]; then
            pushd ${1%/*} > /dev/null
            echo $PWD/${1##*/}
            popd > /dev/null
        else
            echo $PWD/$1
        fi
    fi
} # This function prints the full path of the first argument, if it is a relative path; it prints the original path if it is already a full path.
for i in "$@"
do
    if [[ $i == '.' ]]; then
        ln -s "$PWD" ~/Desktop/ && echo "Link to $PWD created on Desktop!"
    else
        ln -s "$(fulldir "$i")" ~/Desktop/ && echo "Link to $(fulldir "$i") created on Desktop!"
    fi
done
