#!/bin/bash

# This bash script uses NCO commands to post-process CESM model outputs.
# Paramters:
# 1 - Model component (directory)
# 2 - Variable from component
# 3 - Start year
# 4 - End year
# 5 - Time series ID (h0, h1, h2, h3, etc.)
# 6 - Ensemble member (001, 002, 003, 004, 005, etc.)

sim="b.e21.B1850cmip6.f09_g17.CESM2-SF-AA_EE.n8.$6"   # name of the model
user="07644/oxygen"		# user id on Lonestar6
comp=$1
var=$2
start_yrs=$3			# first $start_yrs years of data to be dropped
run_yrs=$4			# the ending year
hval=$5

archdir="/scratch/07931/dunyuliu/CESM2.1.3/cesm_archive/${sim}/${comp}/hist" # directory to artchived hist data
scratchdir="/scratch/07644/oxygen/cesm2_output/${sim}/${comp}"		  # directory for output
mkdir -p ${scratchdir}
mkdir -p "${scratchdir}/ts_init"

# Check if the concatenated file has already been created
if [ -e ${scratchdir}/${var}.${hval}.${6}.${start_yrs}-${run_yrs}.nc ]
then
    echo "Redundant: '${scratchdir}/${var}.${hval}.${6}.${start_yrs}-${run_yrs}.nc' exists, skipping."
    exit 1
fi   

echo "Calculating initial time series: '${var}.${sim}.${start_yrs}-${run_yrs}.nc' from ${hval} variable list"
FILE_PATH="${archdir}/*"
for FILE in $FILE_PATH
do
    if [[ $FILE == *"${hval}"* ]] && [[ $FILE == *".nc" ]]; then 
    if [[ $hval == "h0" ]]
    then
        NAME=${FILE: -14}
        YEAR=$(( ${NAME: -10: -6} ))
	OUTPUT_PATH=${scratchdir}/ts_init/${var}.${hval}.${start_yrs}.${run_yrs}${NAME}
        if (( YEAR >= start_yrs )) && (( YEAR <= run_yrs )) && ! [ -e $OUTPUT_PATH ]
        then
            ncks -O -v ${var} ${FILE} $OUTPUT_PATH
        fi
    else
        NAME=${FILE: -23}
        YEAR=$(( ${NAME: -19: -15} ))
	OUTPUT_PATH=${scratchdir}/ts_init/${var}.${hval}.${start_yrs}.${run_yrs}${NAME}
        if (( YEAR >= start_yrs)) && (( YEAR <= run_yrs )) && ! [ -e $OUTPUT_PATH ]
        then
            ncks -O -v ${var} ${FILE} $OUTPUT_PATH
	fi
      fi
    fi
done

echo "Concatenating '${scratchdir}/${var}.${hval}.${6}.${start_yrs}-${run_yrs}.nc'"
ncrcat -h -O ${scratchdir}/ts_init/${var}.${hval}.${start_yrs}.${run_yrs}* ${scratchdir}/${var}.${hval}.${6}.${start_yrs}-${run_yrs}.nc
