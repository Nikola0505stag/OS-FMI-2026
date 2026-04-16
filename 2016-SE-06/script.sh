#!/bin/bash

if ! [[ $# -eq 1 ]]; then
	echo "Only one arguments expected!"
	exit 1
fi

if ! [ -f $1 ]; then
	echo "Only files allowed!"
	exit 1
fi

cat $1 | awk 'BEGIN{counter=1} {print counter ". " $0} { counter+=1}' | cut -d " " -f 1,5-| sort -t " " -k 2
