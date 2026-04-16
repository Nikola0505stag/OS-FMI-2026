#!/bin/bash

if ! [ $# -ge 1 ]; then
	echo "Expected atleast one argument!"
	exit 1
fi

if [ $# -gt 2 ]; then
	echo "The max number of arguments is two"
	exit 1
fi

if ! [ -d $1 ]; then 
	echo "Argument 1 can be only directory!"
	exit 1
fi

if [ $# -eq 1 ]; then

	find . -type l ! -xtype l -exec sh -c 'stat "$1" | head -n 1' _ {} \; | awk '$1 = $1 {print}' | cut -d " " -f 2- | tr "'" " " | awk '$1 = $1 {print}'
	find -xtype l | wc -l | awk '{print "Broken symlinks: " $1}'

else

	if ! [ -f $2 ]; then
		echo "Argument 2 can only be file"
		exit 1
	fi

	find . -type l ! -xtype l -exec sh -c 'stat "$1" | head -n 1' _ {} \; | awk '$1 = $1 {print}' | cut -d " " -f 2- | tr "'" " " | awk '$1 = $1 {print}' > "$2"
	find -xtype l | wc -l | awk '{print "Broken symlinks: " $1}' >> "$2"
fi
