#!/bin/bash -l
#SBATCH -A ZETTASCALE-PORTING-DAWN-GPU
#SBATCH --partition=pvc9 # Dawn PVC partition
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --ntasks-per-node=8   # Number of tasks (usually number of MPI ranks)
#SBATCH --gres=gpu:4 # Number of requested GPUs per node
#SBATCH --time=00:30:00
#SBATCH --qos=INTR


cd /rds/user/jk945/hpc-work/nanoGPT/
source setup-env.sh
conda activate nanogpt

mpirun -n 8 -ppn 8 -prepend-rank hostname

mpirun -n 8 -ppn 8 python train.py config/train_gpt2.py --compile=False --wandb_log=False

