#!/bin/bash

if ! [ $# -eq 3 ]; then
	echo "Expected 3 arguments!"
	exit 1
fi

if ! [ -d $1 ]; then
	echo "Argument 1 can only be dir!"
	exit 1
fi

if ! [ -d $2 ]; then
	echo "Argument 2 can only be dir!"
	exit 1
fi

COUNT_FILES=$(find "$2" | wc -l)

if ! [ "$COUNT_FILES" -eq 1 ]; then
	echo "The second dir must be empty!"
	exit 1
fi

FILES_TO_MOVE=$(find "$1" -regex ".*"$3".*")

for LINE in $FILES_TO_MOVE; do

	RELATIVE_PATH=${LINE#"$1"/}
	DIR_PATH=$(dirname "$RELATIVE_PATH")

	mkdir -p "$2/$DIR_PATH"
	mv "$LINE" "$2/$RELATIVE_PATH"

done
