#!/bin/bash
#SBATCH --job-name=compile_ml_libs               # Job name
#SBATCH --nodes=1
#SBATCH --cpus-per-task=192
#SBATCH --ntasks=1
#SBATCH --time=04:00:00               # Time limit hrs:min:sec
#SBATCH --partition antero

# Compile each of the ML Libraries
ARCH_FILE=architectures/linux-rocm-5.7.0.mk

source environments/pytorch/pinoak-rocm-5.7.0
srun -n 1 -c 192 make build_torch ARCH_FILE=$ARCH_FILE

source environments/tensorflow/pinoak-rocm-5.7.0
srun -n 1 -c 192 make build_tensorflow ARCH_FILE=$ARCH_FILE

source environments/onnxruntime/pinoak-rocm-5.7.0
srun -n 1 -c 192 make build_onnxruntime ARCH_FILE=$ARCH_FILE
