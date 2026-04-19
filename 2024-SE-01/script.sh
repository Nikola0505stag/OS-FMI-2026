#!/bin/bash

map_file=$(mktemp)

files=()

for arg in "$@"; do
    if [[ "$arg" == -R* ]]; then
        pair="${arg#-R}"
        word1="${pair%%=*}"
        word2="${pair#*=}"
        marker=$(pwgen 16 1)
        echo "$word1 $marker $word2" >> "$map_file"
    else
        files+=("$arg")
    fi
done

for file in "${files[@]}"; do
    [ ! -f "$file" ] && continue

    while read -r w1 mark w2; do
        sed -i "/^#/! s/\<$w1\>/$mark/g" "$file"
    done < "$map_file"

    while read -r w1 mark w2; do
        sed -i "/^#/! s/$mark/$w2/g" "$file"
    done < "$map_file"
done

rm "$map_file"
	
