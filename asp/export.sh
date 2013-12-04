#!/bin/sh

name="./exports/$(date +%y.%m.%d_%H.%M.%S)" 
echo $name
grep presentation answerset.txt | sed 's/\(.*\)\([0-9]\)\(.*\)/\1 \2 \3;/' | sort -n -k 2 > $name.txt

cat answerset.txt > $name.ans
cat storyspec.txt > $name.spec

./bundle.sh
