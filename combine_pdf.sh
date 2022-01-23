#!/bin/bash

function combine() {
    # combine out in1 in2 in3 ...
    params=( "$@" )
    out=("${params[@]::1}")
    ins=("${params[@]:1}")
    echo "----------------------"
    echo "Combining input files:"
    for i in "${ins[@]}"; do echo -e "\t$i"; done
    echo "into output:"
    echo -e "\t$out"
    qpdf --empty --pages "${ins[@]}" -- "${out}"
    if [ $? -eq 0 ]; then
        echo "Output written to $out"
    else
        echo "Failed to combine"
    fi
}

if [ $# -eq 0 ]; then
    echo "No argument, combining based on suffix..."
    for file in *.pdf; do
        if [[ "$file" =~ ^.*_[0-9]+.pdf ]]; then
            base="${file%_*}"
            out="${base}.pdf"
            if [ ! -f "$out" ]; then
                touch "$out"
                ins=()
                for i in "${base}"_*.pdf; do 
                    ins+=("$i")
                done
                combine "$out" "${ins[@]}"
            fi
        fi
    done
else
    out=combined_$(date +%Y%m%d_%H%M%S).pdf
    combine "$out" "$@"
fi
