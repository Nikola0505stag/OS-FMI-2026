#!/bin/bash

TODAY=$(date +%Y%m%d)

for file in "$@"; do
    TEMP_FILE=$(mktemp)
    
    FOUND_SERIAL=0

    while read -r line; do
        if echo "$line" | grep -qE "[0-9]{10}" && [ $FOUND_SERIAL -eq 0 ]; then
            
            OLD_SERIAL=$(echo "$line" | grep -oE "[0-9]{10}")
            
            DATE=$(echo "$OLD_SERIAL" | cut -c 1-8)
            OTHER=$(echo "$OLD_SERIAL" | cut -c 9-10)

            if [ "$DATE" -lt "$TODAY" ]; then
                NEW_SERIAL="${TODAY}00"
            else
                NEW_TT=$(printf "%02d" $(( 10#$OTHER + 1 )))
                NEW_SERIAL="${TODAY}${NEW_TT}"
            fi

            echo "$line" | sed "s/$OLD_SERIAL/$NEW_SERIAL/" >> "$TEMP_FILE"
            
            FOUND_SERIAL=1
        else
            echo "$line" >> "$TEMP_FILE"
        fi
        
    done < "$file"

    cat "$TEMP_FILE" > "$file"
    rm "$TEMP_FILE"
    
    echo "Updated $file"
done
