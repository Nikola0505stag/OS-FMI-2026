#!/bin/bash

if ! [ $# -eq 2 ]; then
	echo "Two arguments expected!"
	exit 1
fi

if ! [ -f $1 ]; then
	echo "Only files allowed as arguments"
fi

if ! [ -f $2 ]; then
	echo "Only files allowed as arguments"
fi

FILE1_SIZE=$(grep -c "$1" $1)
FILE2_SIZE=$(grep -c "$2" $2)

if [ $FILE1_SIZE -ge $FILE2_SIZE ]; then
	WORKING_FILE=$1
else
	WORKING_FILE=$2
fi

cat $WORKING_FILE | cut -d . -f 2 | awk -v file=$WORKING_FILE ' $1 == file {print}' | sort | cut -d - -f 2,3 > $WORKING_FILE.songs
