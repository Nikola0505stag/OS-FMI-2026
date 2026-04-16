#!/bin/bash

if [ $UID -ne 1 ]; then
	echo "Only root can execute!"
	exit 1
fi

USERS=$(ps -e -o user | tail -n +2 | sort -k 1 | uniq)

for user in $users; do
	TOTAL_RSS=0
	COUNT=0
	MAX_RSS=0
	MAX_PID=0

	while read PID RSS; do
		TOTAL_RSS=$((TOTAL_RSS + RSS))
		COUNT=$((COUNT + 1))

		if [ $RSS -gt $MAX_RSS ]; then
			MAX_RSS=$RSS
			MAX_PID=$PID
		fi

	done < <(ps -u "$user" -o pid,rss --no-headers)
	
	if [ $COUNT -gt 0 ]; then
		echo "User: $user | Processes: $count | Total RSS: $total_rss"

		AVG_RSS=$((TOTAL_RSS / COUNT))

		if [ $MAX_RSS -gt $((2 * AVG_RSS)) ]; then
			echo "  [!] Killing process $max_pid (RSS: $max_rss) for user $user - exceeds 2x average ($avg_rss)"
			kill -9 "$MAX_PID"
		fi
	fi
done
