
# BSD 2-Clause License
#
# Copyright (c) 2024, Hewlett Packard Enterprise
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

OS = linux
ARCHITECTURE=x64
PYTORCH_VERSION=v2.2.2

TORCH_CMAKE_OPTIONS =
TORCH_CMAKE_OPTIONS += -DUSE_ROCM=ON -DUSE_RCCL=ON -DUSE_NCCL=OFF -DUSE_CUDA=OFF -DROCM_SOURCE_DIR=${ROCM_PATH} -DBUILD_PYTHON=OFF
# # Extra definitions for AOTriton
# TORCH_CMAKE_OPTIONS += -DAMDHSA_LD_PRELOAD=${ROCM_PATH}/lib/libhsa-runtime64.so -DAOTRITON_EXTRA_COMPILER_OPTIONS=-I${ROCM_PATH}/include

PYTORCH_ROCM_PREBUILD_TARGETS = pytorch_amd_prebuild setup_triton patch_aotriton
PYTORCH_ROCM_PREBUILD_TARGETS = pytorch_amd_prebuild

# patch_aotriton:
# 	cd pytorch; git apply $(PWD)/patches/aotriton.patch

# From PyTorch for ROCm instructions
# https://github.com/pytorch/pytorch/blob/v2.3.1/README.md?plain=1#L241-L245
# For at ROCm 5.5.0 and later, also need to patch one of the ATen files
pytorch_amd_prebuild:
	cd pytorch; python tools/amd_build/build_amd.py &> /dev/null
	sed -i 's/attr.memoryType/attr.type/g' pytorch/aten/src/ATen/hip/detail/HIPHooks.cpp
	cd pytorch; git patch ../patches/pytorch/caffe2_rocm_path.patch

# AOTRITON_DIR = /lus/scratch/$(USER)/tmp/triton
# Needed because PyTorch will automatically try to download into the $HOME/.triton
# which will exceed the home quota
# setup_triton:
# 	rm -rf $(AOTRITON_DIR)
# 	mkdir -p $(AOTRITON_DIR)
# 	rm -rf ~/.triton; ln -sf /lus/scratch/$(USER)/tmp/triton ~/.triton
