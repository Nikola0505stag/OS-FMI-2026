#!/bin/bash

LINES_TO_PRINT=10
N_THERE="false"
if [ $1 == '-n' ]; then

	if ! echo $2 | grep -qE "^([1-9][0-9]*)$"; then
		echo "If the first argument is -n the second should be number!"
		exit 1
	fi

	LINES_TO_PRINT=$2
	N_THERE="true"
fi

if [ $N_THERE == 'true' ]; then
	START_FROM=3
else 
	START_FROM=1
fi

TMP_FILE=$(mktemp)
FINAL_FILE=$(mktemp)
for (( i=$START_FROM; i <= $#; i++ )); do
	
	ID=$(echo ${!i} | cut -d . -f 1)
	
	> $TMP_FILE

	while read -r line; do

		TIME=$(echo $line | cut -d " " -f 1,2)
		BULSHIT=$(echo $line | cut -d " " -f 3-)
		
		echo $TIME " " $ID " " $BULSHIT >> $TMP_FILE
		
	done < ${!i}

	cat $TMP_FILE | head -n $LINES_TO_PRINT >> $FINAL_FILE

done

cat $FINAL_FILE | sort -k 1,2 | tr -d "[" | tr -d "]" | tr "   " " "	

rm $TMP_FILE
rm $FINAL_FILE
