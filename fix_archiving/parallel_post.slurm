#!/bin/bash
#SBATCH -J postp.CESM2.goob          # job name
#SBATCH -o launcher.o%j             # output and error file name (%j expands to SLURM jobID)
#SBATCH -N 1                        # number of nodes requested
#SBATCH -n 20                       # total number of tasks to run in parallel
#SBATCH -p normal                   # queue (partition) 
#SBATCH -t 48:00:00                 # run time (hh:mm:ss) 
#SBATCH -A ATM22002                 # Allocation project name to charge job against
#SBATCH --mail-user=cameron.cummins@utexas.edu
#SBATCH --mail-type=begin  # email me when the job starts
#SBATCH --mail-type=end    # email me when the job finishes

module load launcher # Load the module launcher on Lonestar6.

export LAUNCHER_WORKDIR="/scratch/07644/oxygen/archived_vars" # Put here the work directory that hosts all these scripts.
export LAUNCHER_JOB_FILE="/scratch/07644/oxygen/cesm2_scripts/fix_archiving/parallel_launcher" # It refers to the file parallel_launcher in this repo.

${LAUNCHER_DIR}/paramrun
