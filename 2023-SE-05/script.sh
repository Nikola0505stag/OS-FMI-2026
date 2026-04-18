#!/bin/bash

LIMIT=65536
LOG_FILE=$(mktemp)
ITERATIONS=0

while true; do
    ITERATIONS=$((ITERATIONS + 1))
    
    SNAPSHOT=$(ps -e -o comm=,rss= | awk '{mem[$1]+=$2} END {for (c in mem) print c, mem[c]}')

    FOUND_ABOVE_LIMIT=0
    
    while read -r cmd mem; do
        if [ "$mem" -gt "$LIMIT" ]; then
            echo "$cmd" >> "$LOG_FILE"
            FOUND_ABOVE_LIMIT=1
        fi
    done <<< "$SNAPSHOT"

    if [ "$FOUND_ABOVE_LIMIT" -eq 0 ]; then
        break
    fi

    sleep 1
done

if [ -s "$LOG_FILE" ]; then
    echo "Команди, заемали над $LIMIT памет в поне половината поглеждания ($((ITERATIONS / 2)) пъти):"
    
    # sort: подрежда имената
    # uniq -c: преброява колко пъти се повтаря всяко име (дава изход: "брой име")
    sort "$LOG_FILE" | uniq -c | while read -r count cmd; do
        if [ $((count * 2)) -ge "$ITERATIONS" ]; then
            echo "- $cmd (видян $count пъти от общо $ITERATIONS)"
        fi
    done
else
    echo "Няма намерени процеси над лимита."
fi

# Почистване
rm "$LOG_FILE"
