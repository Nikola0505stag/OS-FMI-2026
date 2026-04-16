#!/bin/bash

if [ $# -lt 1 ]; then
	echo "At least one argument expected!"
	exit 1
fi

if [ $# -ge 3 ]; then
	echo "Argumets above second are forbidden!"
	exit 1
fi

if ! [ -d $1 ]; then
	echo "First argument must be directory!"
	exit 1
fi

if [ $# -eq 1 ]; then

	find "$1" -xtype l 

else 
	if ! echo "$2" | grep -qE "^([1-9][0-9]*|0)$"; then
		echo "Second argument must be integer"
		exit 1
	fi
	
	find "$1" -links "$2" -type f
	
fi
