#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "You need to be root to exec"
    exit 1
fi    

cat /etc/passwd | grep -v -E ".*home.*"
