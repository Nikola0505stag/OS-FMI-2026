#!/bin/bash

if ! [ $# -eq 2 ]; then
	echo "Expected 2 arguments!"
	exit 1
fi

if ! [ -f $1 ]; then 
	echo "Argument 1 must be file!"
	exit 1
fi

if ! [ -d $2 ]; then
	echo "Argument 2 must be directory!"
	exit 1
fi

if find $2 -mindepth 1 ! -regex ".*\.log" | grep -qE ".*"; then
	echo "Only log files can be in directory!"
	exit 1
fi

echo "hostname,phy,vlans,hosts,failover,VPN-3DES-AES,peers,VLAN Trunk Ports,license,SN,key" > $1

while read -r log_file; do
    
    HOSTNAME=$(basename "$log_file" .log)
    
    PHY=""; VLANS=""; HOSTS=""; FAILOVER=""; VPN=""; PEERS=""; VLAN_TRUNK=""; LICENSE=""; SN=""; KEY=""

    while read -r row; do
        COMMAND=$(echo "$row" | cut -d : -f 1 | xargs)
        VALUE=$(echo "$row" | cut -d : -f 2 | xargs)

        case "$COMMAND" in
            "Maximum Physical Interfaces") PHY="$VALUE" ;;
            "VLANs")                       VLANS="$VALUE" ;;
            "Inside Hosts")                HOSTS="$VALUE" ;;
            "Failover")                    FAILOVER="$VALUE" ;;
            "VPN-3DES-AES")                VPN="$VALUE" ;;
            "Total VPN Peers")             PEERS="$VALUE" ;;
            "VLAN Trunk Ports")            VLAN_TRUNK="$VALUE" ;;
            "Serial Number")               SN="$VALUE" ;;
            "Running Activation Key")      KEY="$VALUE" ;;
        esac
    done < "$log_file"

    echo "$HOSTNAME,$PHY,$VLANS,$HOSTS,$FAILOVER,$VPN,$PEERS,$VLAN_TRUNK,$LICENSE,$SN,$KEY" >> "$1"

done < <(find "$2" -mindepth 1 -type f -name "*.log")
