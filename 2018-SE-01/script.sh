#!/bin/bash

if ! [ $# -eq 1 ]; then
    echo "Only 1 argument expected!"
    exit 1
fi

if [ ! -d "$1" ]; then
    echo "Error: $LOGDIR is not a directory."
    exit 1
fi

TMP_FILE=$(mktemp)

find "$1" -mindepth 4 -maxdepth 4 -type f -name ".*.txt" | while read -r filepath; do
	
	FRIEND=$(basename "$(dirname "$filepath")")

	lines=$(wc -l < "$filepath")

	echo "$lines $friend" >> "$TMP_FILE"
done 

sort -k 2 "$TMP_FILE" | awk '{
    if ($2 == prev_friend) {
        sum += $1
    } else {
        if (prev_friend != "") print sum, prev_friend
        sum = $1
        prev_friend = $2
    }
} 
END { print sum, prev_friend }' | sort -nr | head -n 10

rm "$TMP_FILE"
