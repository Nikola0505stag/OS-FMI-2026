#!/bin/bash

TEMP=$(mktemp)
MAX_SUM=0

while read -r line; do

    if ! echo "$line" | grep -qE "^-?([1-9][0-9]*|0)$"; then
        continue
    fi

    ABS_VALUE=${line#-}
    
    CURRENT_SUM=0
    for (( i=0; i<${#ABS_VALUE}; i++ )); do
        CURRENT_SUM=$(( CURRENT_SUM + ${ABS_VALUE:$i:1} ))
    done

    echo "$line $CURRENT_SUM" >> "$TEMP"

    if (( CURRENT_SUM > MAX_SUM )); then
        MAX_SUM=$CURRENT_SUM
    fi
done

grep " $MAX_SUM$" "$TEMP" | cut -d ' ' -f 1 | sort -n | uniq | head -n 1

rm -f "$TEMP"
