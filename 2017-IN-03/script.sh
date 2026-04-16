#!/bin/bash

cat /etc/passwd | cut -d : -f 6 | xargs -I {} find {} -maxdepth 2 -type f -printf "%Y\t%u\t%p\n" 2>/dev/null | sort -nr | head -n 1

