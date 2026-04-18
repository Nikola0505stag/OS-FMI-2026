#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <directory>" >&2
    exit 1
fi

DIR="$1"

if [ ! -d "$DIR" ]; then
    echo "Error: '$DIR' is not a directory." >&2
    exit 2
fi

INFO_FILE=$(mktemp)

find "$DIR" -type f -printf "%i " -exec md5sum {} \; > "$INFO_FILE"

declare -A SEEN_CONTENT
declare -A SEEN_INODE

echo "--- Files recommended for deletion ---"

while read -r inode hash filename; do
    
    if [[ -n ${SEEN_INODE[$inode]} ]]; then
        echo "$filename"
        continue
    fi

    if [[ -n ${SEEN_CONTENT[$hash]} ]]; then
        echo "$filename"
        continue
    fi

    SEEN_INODE[$inode]=1
    SEEN_CONTENT[$hash]=1

done < "$INFO_FILE"

rm "$INFO_FILE"
