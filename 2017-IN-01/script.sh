#!/bin/bash

if ! [ $# -eq 3 ]; then 
	echo "Three arguments expected!"
	exit 1
fi

if ! [ -f "$1" ]; then
	echo "Only files allowed for argument one"
	exit 1
fi

if ! [ -n "$2" ]; then 
	echo "Empty string not allowed"
	exit 1
fi

if ! [ -n "$3" ]; then 
	echo "Empty string not allowed"
	exit 1
fi

KEY1="$(grep -E "^${2}=.*$" "$1" | cut -d = -f 2)"
KEY2="$(grep -E "^${3}=.*$" "$1" | cut -d = -f 2)"

FILE1=$(mktemp)
FILE2=$(mktemp)

echo "$KEY1" | tr ' ' '\n' | sort > $FILE1
echo "$KEY2" | tr ' ' '\n' | sort > $FILE2

RESULT_KEY2=$(comm -13 $FILE1 $FILE2 | tr '\n' ' ')

RES_FILE=$(mktemp)

awk -F'=' -v temp="$3" -v res="$RESULT_KEY2" '
			{
			if ($1 == temp) {
				print $1 "=" res
			} else {
				print $0
			}
			}' "$1" > $RES_FILE

cat $RES_FILE > "$1"

rm $FILE1
rm $FILE2
rm $RES_FILE
