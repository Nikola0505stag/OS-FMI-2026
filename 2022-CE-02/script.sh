#!/bin/bash

if ! [ $# -eq 1 ]; then
	echo "Expected only one arguemnt!"
	exit 1
fi

TEMP_FILE=$(mktemp)

while read -r line; do

	if echo $line | grep -qE "$1"; then
		echo $line | sed 's/enabled/disabled/' >> $TEMP_FILE
	else
		echo $line >> $TEMP_FILE
	fi

done < file.txt

cat $TEMP_FILE > file.txt
rm $TEMP_FILE
