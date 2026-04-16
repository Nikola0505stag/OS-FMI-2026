#!/bin/bash

if ! [ $# -eq 2 ]; then
	echo "Expected two arguments!"
	exit 1
fi

if ! [ -f $1 ]; then
	echo "Argument 1 can only be file!"
	exit 1
fi

if ! [ -d $2 ]; then
	echo "Argument 2 can only be directory!"
	exit 1
fi

if  find $2 -mindepth 1 | grep -qE ".*"; then
	echo "Directory must be empty!"
	exit 1
fi

touch "$2"/dict.txt
FILE="$2/dict.txt"

cat file.txt | cut -d : -f 1 | cut -d " " -f 1,2 | sort | uniq | awk -v ind=1 '{print $0";"ind++}' > $FILE

cat dir/dict.txt | cut -d ";" -f 2 | xargs -I {} touch "$2/{}.txt"

TEMP=$(cat $FILE)

while read -r line; do

	TEMP=$(echo $line | cut -d ";" -f 2)
	NAME_TO_FIND=$(echo $line | cut -d ";" -f 1)

	cat "$1" | grep -E "$NAME_TO_FIND" > "$2/$TEMP.txt"


done < "$FILE"
