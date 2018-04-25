#/bin/bash
if [[ $# -ne 0 && $1 == '-h' ]]; then 
    echo "This script yanks the following line to the clipboard:"
    echo '\([^\(\)]*([0-9]{4}|n\.d\.)\)'
    echo "(This is the regular expression for in-text citations)"
else
    printf '\([^\(\)]*([0-9]{4}|n\.d\.)\)' | xclip -selection c
    echo "Copied the following to the clipboard:"
    echo '\([^\(\)]*([0-9]{4}|n\.d\.)\)'
fi
