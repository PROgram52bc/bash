#!/usr/bin/env bash

debug() {
    :
    # echo ==DEBUG: $@
}

# $1: pattern to be matched, can contain braces
# $2: the actual string
match() {
    file="$2"
    pattern="$1"

    restore=$(set +o)
    set -f
    exp=($(eval echo "$pattern")) # try to expand braces, but not to file names
    eval "$restore"

    if [ ${#exp[@]} -eq 1 ]; then
        debug "not expanding"
        [[ "$file" == $pattern ]]
        return $?
    else
        # match succeeds if one of the expanded patterns succeeds
        debug "expanding pattern $file to:"
        for expanded in ${exp[@]}; do
            debug $expanded
            if [[ "$file" == $expanded ]]; then
                debug match!
                return 0
            fi
            debug does not match
        done
        return 1
    fi
}

if [ "$1" != "--source-only" ]; then
    file="abc.jpg"
    pattern1="abc.{pdf,jpg}"
    pattern2="*.{pdf,jpg}"
    pattern3="*.jpg"
    pattern4="[abcdef]??.jpg"

    match "$pattern1" "$file" && echo "succeeds" || echo "fails"
    match "$pattern2" "$file" && echo "succeeds" || echo "fails"
    match "$pattern3" "$file" && echo "succeeds" || echo "fails"
    match "$pattern4" "$file" && echo "succeeds" || echo "fails"

    file="abc.sh"
    pattern1="*.sh"
    match "$pattern1" "$file" && echo "succeeds" || echo "fails"
fi
