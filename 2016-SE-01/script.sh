#!/bin/bash

if ! [ $# -eq 1 ]; then
	echo "Only one argument allowed!"
	exit 1
fi

if ! [ -d $1 ]; then
	echo "Only directory allowed as argument"
	exit 1
fi

find "$1" -xtype l
