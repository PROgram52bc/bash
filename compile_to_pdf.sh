#!/bin/bash
# pattern="^.*\.(png|jpg|jpeg|svg)$"

function _convert() {
    img="$1"
    if [ ! -f "$img" ]; then
        echo "$img doesn't exist, ignored"
        return
    fi
    # if [[ ! "$img" =~ $pattern ]]; then
    #     echo "$img doesn't match $pattern, ignored"
    #     return
    # fi
    base=${img%.*}
    echo "Converting $img into ${base}.pdf..."
    case ${img} in
        *.svg)
            inkscape --file="$img" --export-area-drawing --without-gui --export-pdf="${base}.pdf"
            ;;
        *.png)
            # remove alpha channel if there is
            noalpha="__${img}"
            if [ $(identify -format %A "${img}") == "True" ]; then
                echo "Removing alpha..."
                convert "${img}" -background white -alpha remove -alpha off "${noalpha}"
            else
                cp "${img}" "${noalpha}"
            fi
            img2pdf -o "${base}.pdf" "${noalpha}"
            rm -f "${noalpha}"
            ;;
        *.jpg|*.jpeg|*.gif|*.webp)
            img2pdf -o "${base}.pdf" "${img}"
            ;;
        *)
            echo "unrecognized pattern ${img}"
    esac
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


