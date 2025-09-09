#!/bin/sh

source ./mg5env.sh

if [[ ${MG5_GPU_MODULE} != "" ]]; then module load ${MG5_GPU_MODULE}/${MG5_GPU_VERSION}; fi
if [[ ${MG5_GCC_MODULE} != "" ]]; then module load ${MG5_GCC_MODULE}/${MG5_GCC_VERSION}; fi
if [[ ${MG5_PYTHON_MODULE} != "" ]]; then module load ${MG5_PYTHON_MODULE}/${MG5_PYTHON_VERSION}; fi

if [ "x$1" != "x" ]; then MG5_PROC=$1; fi

cd ${MG5_HOME}/sw/madgraph4gpu/MG5aMC/mg5amcnlo
MADGRAPH_${MG5_GPU_NAME}_ARCHITECTURE=${MG5_GPU_ARCH} ./bin/mg5_aMC cmd_proc/proc_${MG5_PROC}.mg5
