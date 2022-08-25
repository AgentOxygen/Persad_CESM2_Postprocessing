#!/bin/bash

# Paramters
# 1 - Ensemble member (001, 002, 003, 004, 005)
# 2 - Model component (atm, ice, lnd, etc)
# 3 - Variable list, path
# 4 - h-value associated with variable list
# 5 - Chunk size in years
# 6 - File name year string index, indicates where year digits start in the file name

EN_NUM=$1
MODEL_COMP=$2
VAR_LIST_PATH=$3
H_VAL=$4
CHUNK_SIZE=$5
YEAR_INDEX=$(( -1*$6 ))

SIM_NAME="b.e21.B1850cmip6.f09_g17.CESM2-SF-AA_EE.n8.${EN_NUM}"
INPUT_DIR="/scratch/07931/dunyuliu/CESM2.1.3/cesm_archive/${SIM_NAME}/${MODEL_COMP}/hist"
OUTPUT_DIR="/scratch/07644/oxygen/cesm2_output/${SIM_NAME}/${MODEL_COMP}"
MAX_YEAR=2015
START_YEAR=1850
TMP_LOG=$(uuidgen)

mkdir -p ${OUTPUT_DIR}
mkdir -p "tmp"

while (( $START_YEAR <= $MAX_YEAR ))
do
    END_YEAR=$((START_YEAR+$CHUNK_SIZE-1))
    if (( $END_YEAR > $MAX_YEAR ))
    then
	END_YEAR=$MAX_YEAR
    fi
    
    FILE_LIST=""
    for FILE in $INPUT_DIR/*$H_VAL*.nc
    do
	YEAR=$(( ${FILE: $(( -4 + YEAR_INDEX )): $YEAR_INDEX} ))
	if (( YEAR >= START_YEAR )) && (( YEAR <= END_YEAR ))
	then
	    FILE_LIST="${FILE_LIST} $FILE"
	fi
    done
    
    while IFS=' ' read -ra LINE
    do
	VAR=${LINE[1]}
	OUTPUT_PATH="${OUTPUT_DIR}/${VAR}.${H_VAL}.${EN_NUM}.${START_YEAR}-${END_YEAR}.nc"
	if ! [ -e $OUTPUT_PATH ]
	then
	    echo "Outputting ${VAR}.${H_VAL}.${EN_NUM}.${START_YEAR}-${END_YEAR}.nc"
	    ncrcat -h -v $VAR $FILE_LIST $OUTPUT_PATH > "tmp/${TMP_LOG}.txt" 2>&1
	else
	    echo "${VAR}.${H_VAL}.${EN_NUM}.${START_YEAR}-${END_YEAR} exists. Skipping."
	fi
    done < "$VAR_LIST_PATH"
    
    
    START_YEAR=$((START_YEAR+$CHUNK_SIZE))
done
    
