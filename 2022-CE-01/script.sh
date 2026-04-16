#!/bin/bash

# $1 = number
# $2 = prefix symbol
# $3 = unit symbol

if ! [ $# -eq 3 ]; then
	echo "Expected 3 arguments!"
	exit 1
fi

PREFIX_LINE=$(cat prefix.csv | grep -E ".*,$2,.*")

UNIT_LINE=$(cat base.csv | grep -E ".*,$3,.*")

UNIT_SYMBOL=$(echo $UNIT_LINE | cut -d ',' -f 2)
UNIT_NAME=$(echo $UNIT_LINE | cut -d ',' -f 1)
MEASURE=$(echo $UNIT_LINE | cut -d ',' -f 3)

NUMBER=$(echo $PREFIX_LINE | cut -d ',' -f 3)

RESULT_NUMBER=$(echo "NUMBER * $1" | bc)
echo $RESULT_NUMBER $UNIT_SYMBOL "(" $MEASURE "," $UNIT_NAME ")" 
