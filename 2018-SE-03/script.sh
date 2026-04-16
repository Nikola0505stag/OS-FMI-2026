#!/bin/bash

if ! [ $# -eq 2 ]; then
	echo "Expected 2 artugemnts!"
	exit 1
fi

if ! echo $1 | grep -qE ".*\.csv"; then
	echo "Only files in format .csv allowed!"
	exit 1
fi

if ! echo $2 | grep -qE ".*\.csv"; then
	echo "Only files in format .csv allowed!"
	exit 1
fi

TEMP_FILE=$(mktemp)
PREV_TAIL=""

while read -r line; do
    CURRENT_TAIL=$(echo "$line" | cut -d ',' -f 2-)

    if [ "$CURRENT_TAIL" != "$PREV_TAIL" ]; then
        echo "$line" >> "$TEMP_FILE"
    fi

    PREV_TAIL="$CURRENT_TAIL"

done < <(sort -t ',' -k 2 -k 1,1n "$1")

mv "$TEMP_FILE" "$2"
