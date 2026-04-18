#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <config_file>" >&2
    exit 1
fi

CONFIG_FILE="$1"
WAKEUP_FILE="/proc/acpi/wakeup"

if [ ! -r "$CONFIG_FILE" ]; then
    echo "Error: Configuration file '$CONFIG_FILE' cannot be read." >&2
    exit 2
fi

if [ ! -f "$WAKEUP_FILE" ]; then
    echo "Error: System file '$WAKEUP_FILE' not found. Is ACPI enabled?" >&2
    exit 3
fi

sed 's/#.*//; /^[[:space:]]*$/d' "$CONFIG_FILE" | while read -r dev wanted_status; do
    
    line=$(grep -w "^$dev" "$WAKEUP_FILE")

    if [ -z "$line" ]; then
        echo "Warning: Device '$dev' not found in $WAKEUP_FILE. Skipping..." >&2
        continue
    fi

    current_status=$(echo "$line" | awk '{print $3}' | tr -d '*')

    if [ "$current_status" != "$wanted_status" ]; then
        echo "Changing status of $dev from $current_status to $wanted_status..."
        
        if ! echo "$dev" > "$WAKEUP_FILE" 2>/dev/null; then
            echo "Error: Failed to write to $WAKEUP_FILE. Do you have root privileges?" >&2
        fi
    else
        echo "Device $dev is already $wanted_status. No change needed."
    fi

done
