#!/bin/bash
#SBATCH --job-name=compile_ml_libs               # Job name
#SBATCH --nodes=1
#SBATCH --cpus-per-task=192
#SBATCH --ntasks=1
#SBATCH --time=04:00:00               # Time limit hrs:min:sec
#SBATCH --partition antero

# Compile each of the ML Libraries
SCRIPT_NAME=$(realpath $0)
SCRIPT_PATH=$(dirname $SCRIPT_NAME)
ML_BUILDER_REPO_PATH=$(dirname $SCRIPT_PATH)

source environments/pytorch/pinoak-rocm-5.7.0
srun -n 1 -c 192 make build_torch

source environments/tensorflow/pinoak-rocm-5.7.0
srun -n 1 -c 192 make build_tensorflow

source environments/onnxruntime/pinoak-rocm-5.7.0
srun -n 1 -c 192 make build_onnxruntime