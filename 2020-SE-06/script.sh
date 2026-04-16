#!/bin/bash

# $1 = confing file
# $2 = key
# $3 = value

if ! [ $# -eq 3 ]; then 
	echo "Exptected 3 arguments!"
	exit 1
fi

if ! [ -f $1 ]; then
	echo "Argument 1 must be file!"
	exit 1
fi

TEMP_FILE=$(mktemp)

if ! cat foo.conf | grep -qE "^$2.*=.*"; then
	cat $1 >> $TEMP_FILE
	
	echo $2 " = " $3 "# added at" $(date) "by" $(whoami) >> $TEMP_FILE

	cat $TEMP_FILE > $1
else 
	while read -r line; do

		if ! echo $line | grep -qE "^$2.*=.*"; then
			echo $line >> $TEMP_FILE	
			continue
		fi
	
		KEY=$(echo $line | cut -d = -f 1)
		VALUE=$(echo $line | cut -d = -f 2 | cut -d "#" -f 1)
		COMMENTAR=$(echo $line | cut -d = -f 2 | cut -d "#" -f 2)

		echo "#" $KEY "=" $VALUE "#" $COMMENTAR "# edited at" $(date) "by" $(whoami) >> $TEMP_FILE
		echo $2 " = " $3 "# added at" $(date) "by" $(whoami) >> $TEMP_FILE

	done < $1

	cat $TEMP_FILE > $1
fi

rm $TEMP_FILE
