#!/bin/bash

if ! [ $# -eq 1 ]; then
	echo "Only 1 argument expected!"
	exit 1
fi

if ! [ -f $1 ]; then
	echo "Argument 1 must be file!"
	exit 1
fi

SITES=$(cat "$1" | cut -d " " -f 2 | sort | uniq -c | sort -r | awk '$1 = $1' | cut -d " " -f 2 | head -n 3)

for site in $SITES; do

	HTTP_2=$(cat "$1" | grep -E $site | grep -E -c ".*HTTP/2.0.*")
	HTTP_1=$(cat "$1" | grep -E $site | grep -E -c -v ".*HTTP/2.0.*")

	CLIENTS=$(cat "$1" | grep -E $site | awk '$9 > 302 {print $1}' | sort | uniq -c | sort -nr | head -n 5)

	echo $site "HTTP/2.0: " $HTTP_2 "non-HTTP/2.0: " $HTTP_1
	echo $CLIENTS
	echo " "
done
