#!/bin/bash -l
#SBATCH -A AIRR-P9-DAWN-GPU
#SBATCH --partition=pvc9 # Dawn PVC partition
#SBATCH --nodes=5
#SBATCH --ntasks=40
#SBATCH --ntasks-per-node=8   # Number of tasks (usually number of MPI ranks)
#SBATCH --gres=gpu:4 # Number of requested GPUs per node
#SBATCH --time=12:00:00



# Use this to resubmit as a dependent job
# sbatch --dependency=afterany:<job id> nanogpt.sh

module purge
module restore dawn-2025.1.0

export ZE_FLAT_DEVICE_HIERARCHY="FLAT"
export ZE_AFFINITY_MASK="0,1,2,3,4,5,6,7"
export I_MPI_JOB_RESPECT_PROCESS_PLACEMENT=0
unset CCL_CONFIGURATION_PATH_modshare
export CCL_ZE_IPC_EXCHANGE=pidfd


cd /rds/user/jk945/hpc-work/nanoGPT/
source .nanogpt/bin/activate

export HF_HOME=/rds/user/$USER/hpc-work/nanoGPT/data
export TRITON_CACHE_DIR=/home/jk945/rds/hpc-work/nanoGPT/.triton
#mpirun -n ${SLURM_NTASKS} -ppn ${SLURM_NTASKS_PER_NODE} -prepend-rank hostname

mpirun -n ${SLURM_NTASKS} -ppn ${SLURM_NTASKS_PER_NODE} python train.py config/train_gpt2.py --wandb_log=False 

