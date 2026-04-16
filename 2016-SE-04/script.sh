#!/bin/bash

if ! [ $# -eq 2 ]; then
	echo "Two arguments expected!"
	exit 1
fi

for ARG in "$@"; do
	if ! echo $ARG | grep -q -x -E "^([1-9][0-9]*|0)$"; then
		echo "Only integers allowed as arguments"
		exit 1
	fi
done

if [ $1 -gt $2 ]; then
	echo "Argument 1 must be less then argument 2!"
	exit 1
fi

if ! [ -d a ]; then 
	mkdir a
fi

if ! [ -d b ]; then 
	mkdir b
fi

if ! [ -d c ]; then 
	mkdir c
fi


files=$(find . -maxdepth 1 -mindepth 1 -type f | grep -E ".*\.txt")

IFS=$'\n'
for ARG in $files; do
	FILE_LINES=$(cat $ARG | wc -l)

	if [ "$FILE_LINES" -le $1 ]; then
		mv "$ARG" ./a 
	elif [ "$FILE_LINES" -le $2 -a "$FILE_LINES" -gt $1 ]; then
		mv "$ARG" ./b 
	elif [ "$FILE_LINES" -gt $2 ]; then
		mv "$ARG" ./c 
	fi

done

