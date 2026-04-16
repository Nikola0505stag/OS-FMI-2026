#!/bin/bash

MAX_NUMBER=""

while read -r line; do

    if ! echo "$line" | grep -qE "^-?([1-9][0-9]*|0)$"; then
        continue
    fi

    CURR_NUMBER=$line

    if [ -z "$MAX_NUMBER" ]; then
        MAX_NUMBER=$CURR_NUMBER
        continue
    fi

    ABS_CURR=${CURR_NUMBER#-}
    ABS_MAX=${MAX_NUMBER#-}

    if [ "$ABS_CURR" -gt "$ABS_MAX" ]; then
        MAX_NUMBER=$CURR_NUMBER
    fi

done


cat file.txt | grep -E $MAX_NUMBER  | sort | uniq

