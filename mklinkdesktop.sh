#!/bin/bash
# makes a symbolic link on the desktop. Works for both wsl and linux

function isWSL() {
    if grep -qi microsoft /proc/version; then
        return 0
    else
        return 1
    fi
}

# $1: source
# $2: target
function mklink() {
    if isWSL; then
        echo "making link under WSL..."

        # detect file type
        src=$(realpath $1)
        if [ -f "$src" ]; then
            opt="/D"
        elif [ -d "$src" ]; then
            opt="/J"
        else
            echo "invalid file type for source: $src, must be either a file or a directory, abort."
            exit -1
        fi

        # make Windows path
        head=${src##*/}
        target="$(wslpath -w "$2")\\$head"
        # TODO: use wslpath to concatenate when it is fixed
        # See https://github.com/microsoft/WSL/issues/4908 <2022-11-04, David Deng> #
        # target="$(wslpath -w "$2/$head")"
        echo cmd.exe /C mklink $opt "$target" "$(wslpath -w "$1")"
        cmd.exe /C mklink $opt "$target" "$(wslpath -w "$1")"
    else
        echo "making link under linux..."
        ln -s $(realpath "$1") $(realpath "$2")
    fi
}

for src in "$@"
do
    mklink "$src" ~/Desktop
done
