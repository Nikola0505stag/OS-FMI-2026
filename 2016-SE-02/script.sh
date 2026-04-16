#!/bin/bash

if ! [ $# -eq 1 ]; then
	echo "Expected only one argument!"
	exit 1
fi

if ! echo "$1" | grep -qE "^([1-9][0-9]*|0)$"; then
	echo "Only integer allowed as argument"
	exit 1
fi

if [ "$UID" -ne 0 ]; then
	echo "Only root can execute"
	exit 1
fi

ps -e -o user,pid,rss --no-headers | sort | awk -v limit="$1" '
								{
									user=$1; pid=$2; rss=$3
									total_rss[user] += rss
									if (rss > max_rss[user]) {
										max_rss[user] = rss
										top_pid[user] = pid
									}
								}
								END {
									for (u in total_rss) {
										print "User:", u, "Total RSS:", total_rss[u]
										if (total_rss[u] > limit) {
											print "  -> Killing process", top_pid[u], "for user", u
											system("kill -s SIGTERM " top_pid[u])
											# Може да се добави sleep и после kill -9 за сигурност
										}
									}
								}
							'
