#!/bin/sh

MG5_PROC_DIR=$1
MG5_RUN_OPTS=$2
MG5_NUM_EVTS=$3
MG5_PROC_TAG=$4

MG5_ENV=hpc/conf/${MG5_HPC}.sh
if [[ -e ${MG5_ENV} ]]; then source ${MG5_ENV}; fi

for eva in "${MG5_EVAL_LIST}"; do eval ${eva}; done
for mod in "${MG5_MODULES}"; do module load ${mod}; done

mkdir -p ${MG5_WORK_DIR}
mkdir -p ${MG5_OUTP_DIR}
cd ${MG5_WORK_DIR}

echo ">>>>> MG5_CONF >>>>> PROC_DIR >>>>> ${MG5_PROC_DIR}"
echo ">>>>> MG5_CONF >>>>> RUN_OPTS >>>>> ${MG5_RUN_OPTS}"
echo ">>>>> MG5_CONF >>>>> NUM_EVTS >>>>> ${MG5_NUM_EVTS}"
echo ">>>>> MG5_CONF >>>>> PROC_TAG >>>>> ${MG5_PROC_TAG}"
echo ">>>>> MG5_CONF >>>>> OUTP_DIR >>>>> ${MG5_OUTP_DIR}"
echo ">>>>> MG5_CONF >>>>> WORK_DIR >>>>> ${MG5_WORK_DIR}"

echo ">>>>> MG5_TIME >>>>> START    >>>>> `date`"

tar xvfz ${MG5_HOME}/sw/madgraph4gpu/MG5aMC/mg5amcnlo/${MG5_PROC_DIR}/run_01_gridpack.tar.gz

echo ">>>>> MG5_TIME >>>>> UNTAR    >>>>> `date`"

./run.sh ${MG5_RUN_OPTS} ${MG5_NUM_EVTS} ${SLURM_JOBID}

echo ">>>>> MG5_TIME >>>>> RUN      >>>>> `date`"

cp events.lhe.gz ${MG5_OUTP_DIR}

echo ">>>>> MG5_TIME >>>>> UPLOAD   >>>>> `date`"

tar cvfz ${MG5_OUTP_DIR}/${MG5_SLURM_DIR}.tar.gz .

echo ">>>>> MG5_TIME >>>>> END      >>>>> `date`"
