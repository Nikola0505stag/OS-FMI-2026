#!/bin/bash

if [ $UID -ne 0 ]; then
	echo "Only root can execute!"
	exit 1
fi

ROOT_RSS=$(ps -u root -o rss | awk '$1=$1' | tail -n +2 | paste -sd+ | bc)

while IFS=':' read -r user pass uid gid home shell; do
	
	if [ "$user" == 'root' ]; then continue; fi

	IS_PROBLEMATIC=false

	if ! [ -d "$home" ]; then
		IS_PROBLEMATIC=true
	elif [ "$(stat -c %U "$home" 2>/dev/null)" != "$user" ]; then
		IS_PROBLEMATIC=true
	elif [ "$(stat -c %A "$home" 2>/dev/null | cut -c3)" != "w" ]; then
		IS_PROBLEMATIC=true
	fi

	if [ "$IS_PROBLEMATIC" == true ]; then

		USER_RSS=$(ps -u "$user" -o rss | awk '$1=$1' | tail -n +2 | paste -sd+ | bc)

		if [ "$USER_RSS" -gt "$ROOT_RSS" ]; then
			
			echo "Потребител $user е критичен. Използва $USER_RSS KB (Root: $ROOT_RSS KB). Спиране на процеси..."
			
			pkill -u "$user"
			
		fi
	fi
done < /etc/passwd

