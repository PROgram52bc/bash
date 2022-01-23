#!/bin/bash
pattern="^.*\.(png|jpg|jpeg)$"

function _convert() {
    img="$1"
    if [ ! -f "$img" ]; then
        echo "$img doesn't exist, ignored"
        return
    fi
    if [[ ! "$img" =~ $pattern ]]; then
        echo "$img doesn't match $pattern, ignored"
        return
    fi
    base=${img%.*}
    echo "Converting $img into ${base}.pdf..."
    convert "$img" "${base}.pdf"
    if [ $? -ne 0 ]; then
        echo "Failed to convert $img, abort."
        return
    fi
}

files=()
if [ $# -eq 0 ]; then
    echo "No argument, compiling all files in current directory..."
    for file in *; do
        files+=("$file")
    done
else
    files+=("$@")
fi

for img in "${files[@]}"; do
    _convert "$img"
done


