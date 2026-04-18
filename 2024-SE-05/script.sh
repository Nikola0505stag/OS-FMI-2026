#!/bin/bash

if ! [ $# -eq 2 ]; then
	echo "Expected 2 arguments!"
	exit 1
fi

COMMAND=$1
HISTORY_FILE=$2

CURRENT_DATE=$(date "+%Y-%m-%d %H")
DAY_OF_WEEK=$(date "+%u")
HOUR=$(date "+%H")

VALUE=$($COMMAND 2>/dev/null)
RED_CODE=$?

if ! [ $RED_CODE -eq 0 ]; then
	exit 3
fi

SUM=0
COUNT=0

if [ -f "$HISTORY_FILE" ]; then
    STATS=$(awk -v d="$DAY_OF_WEEK" -v h="$HOUR" '$1==d && $2==h {sum+=$3; cnt++} END {print sum, cnt}' "$HISTORY_FILE")
    SUM=$(echo "$STATS" | cut -d' ' -f1)
    COUNT=$(echo "$STATS" | cut -d' ' -f2)
fi

if [ -n "$COUNT" ] && [ "$COUNT" -gt 0 ]; then
    ALPHA=$(echo "scale=4; $SUM / $COUNT" | bc -l)
    
    TOO_HIGH=$(echo "$VALUE > (2 * $ALPHA)" | bc -l)
    TOO_LOW=$(echo "$VALUE < ($ALPHA / 2)" | bc -l)

    if [ "$TOO_HIGH" -eq 1 ] || [ "$TOO_LOW" -eq 1 ]; then
        printf "%s: %.4f abnormal\n" "$CURRENT_DATE" "$VALUE"
        
        echo "$DAY_OF_WEEK $HOUR $VALUE" >> "$HISTORY_FILE"
        exit 2
    fi
fi

echo "$DAY_OF_WEEK $HOUR $VALUE" >> "$HISTORY_FILE"
