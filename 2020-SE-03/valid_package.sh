#!/bin/bash

if ! [ $# -eq 1 ]; then
	echo "Wrong arguments!"
	exit 1
fi

if ! [ -d $1 ]; then
	echo "Not package!"
	exit 1
fi

NUMBER_OF_ROWS=$(find "$1" -mindepth 1 -maxdepth 1 | wc -l)

if ! [ $NUMBER_OF_ROWS -eq 2 ]; then
	echo "Not package!"
	exit 1
fi

if ! find "$1" -mindepth 1 -name 'version.txt' | grep -qE ".*"; then
	echo "Not package!"
	exit 1
fi

if ! find "$1" -mindepth 1 -name 'tree' | grep -qE ".*"; then
	echo "Not package!"
	exit 1
fi

echo "Valid package!"
exit 0
