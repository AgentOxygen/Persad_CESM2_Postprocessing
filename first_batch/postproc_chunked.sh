#!/bin/bash

# Runs postprocessing script using specified chunk size and variable list
# Parameters:
# 1 - chunk size
# 2 - variable list
# 3 - time series id (h0, h1, h2, h3, etc.)
# 4 - ensemble member (001, 002, 003, 004, 005, etc.)

while read d; do
    IFS=' ' read -ra split <<< "$d"
    echo "Working Var List: ${2} for member ${4}"
    i=1850
    while [[ $i -le 2015 ]]
    do
	START=$i
	END=$(( i+$1-1 ))
	if test $END -gt 2015
	then
	    END=2015
	fi
	./postproc_nco.sh "${split[0]}" "${split[1]}" $START $END $3 $4
	((i = i + $1))
    done
done <$2
