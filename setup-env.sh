#!bin/bash

module purge
module load rhel9/default-dawn
module load intelpython-conda/2025.0

#No need to load MPI - conda will use its own version:
#which mpirun

#set this to a dummy value because Conda defaults
#to using packages installed in ~/.local/lib/pythonX.Y
export PYTHONUSERBASE=intentionally-disabled 

#set this so the Huggingface datasets and cache are downloaded
#to the RDS instead of ~/.cache
export HF_HOME=/rds/user/$USER/hpc-work/nanoGPT/data/openwebtext/
