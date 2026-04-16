#!/bin/bash

if ! [ $# -eq 2 ]; then
	echo "Expected 2 arguments!"
	exit 1
fi

if ! [ -d $1 ]; then
	echo "Argument 1 can only be directory!"
	exit 1
fi

cd "$1"

find . -maxdepth 1 -mindepth 1 | grep -E '.*\-.*\..*\..*\-.*' | grep -E "$2" | cut -d '-' -f 2 | cut -d '.' -f 2 | sort -n -r | head -n 1 | xargs -I {} find . -regex '.*\.{}\..*' 

