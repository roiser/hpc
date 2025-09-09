#!/bin/sh

MG5_ENV=hpc/conf/${MG5_HPC}.sh
if [[ -e ${MG5_ENV} ]]; then source ${MG5_ENV}; fi

for mod in "${MG5_MODULES}"; do module load ${mod}; done

if [ "x$1" != "x" ]; then MG5_PROC=$1; fi

cd ${MG5_HOME}/sw/madgraph4gpu/MG5aMC/mg5amcnlo
eval MADGRAPH_${MG5_GPU_NAME}_ARCHITECTURE=${MG5_GPU_ARCH} ./bin/mg5_aMC cmd_proc/proc_${MG5_PROC}.mg5
