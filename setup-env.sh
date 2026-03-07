#!bin/bash

module purge
module restore dawn-2025.1.0
source .nanogpt/bin/activate

#set this to a dummy value because Conda defaults
#to using packages installed in ~/.local/lib/pythonX.Y
export PYTHONUSERBASE=intentionally-disabled 

#set this so the Huggingface datasets and cache are downloaded
#to the RDS instead of ~/.cache
export HF_HOME=/rds/user/$USER/hpc-work/nanoGPT/data/openwebtext/

