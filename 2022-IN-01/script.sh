#!/bin/bash

if ! [ $# -eq 2 ]; then
	echo "Expected 2 arguments!"
	exit 1
fi

if ! [ -d $1 ]; then
	echo "Argument 1 must be directory!"
	exit 1
fi

if ! [ -d $2 ]; then
	echo "Argument 2 must be directory!"
	exit 1
fi

if find $2 -mindepth 1 | grep -qE ".*"; then
	echo "The second directory must be empty!"
	exit 1
fi

DIR1="$1"
DIR2=$(realpath "$2")

cd "$DIR1"

find . -type f ! -name ".*.swp" | while read -r FILE_PATH; do
	DEST_DIR=$(dirname "$FILE_PATH")

	mkdir -p "$DIR2/$DEST_DIR"

	cp "$FILE_PATH" "$DIR2/$FILE_PATH"
done
