#!/bin/bash

if ! echo $1 | grep -qE "^([1-9][0-9]*|0)$"; then
	echo "The first argument must be number!"
	exit 1
fi

if [ $# -lt 2 ]; then 
	echo "Expected at least 2 arguments!"
	exit 1
fi

TIME_LIMIT=$1
shift
COMMAND="$@"

START_BENCHMARK=$(date +%s.%N)
COUNT=0
ELAPSED=0

while (( $(echo "$ELAPSED < $TIME_LIMIT" | bc -l) )); do

	$COMMAND

	COUNT=$((COUNT + 1))

	CURRENT_TIME=$(date +%s.%N)
	ELAPSED=$(echo "$CURRENT_TIME - $START_BENCHMARK" | bc -l)
done

AVERAGE=$(echo "scale=4; $ELAPSED / $COUNT" | bc -l)

printf "Ran the command '%s' %d times for %.2f seconds.\n" "$COMMAND" "$COUNT" "$ELAPSED"
printf "Average runtime: %.2f seconds.\n" "$AVERAGE"
