#!/bin/sh

HIP_VERSION=
GCC_VERSION=
PYTHON_VERSION=3.11.7
MG5_USER=${SLURM_JOB_USER}
MG5_HOME=${SLURM_SUBMIT_DIR}
MG5_SLURM_DIR=slurm-${SLURM_JOBID}

MG5_PROC_DIR=$1
MG5_RUN_OPTS=$2
MG5_NUM_EVTS=$3
MG5_PROC_TAG=$4

#module load rocm/12.6
#module load gcc/13.2.0
module load cray-python/${PYTHON_VERSION}


MG5_OUTPUT=/projappl/${SLURM_JOB_ACCOUNT}/MG5
if [ ${MG5_PROC_TAG} != "" ]; then MG5_OUTPUT=${MG5_OUTPUT}/${MG5_PROC_TAG}; fi
MG5_OUTPUT=${MG5_OUTPUT}/${MG5_SLURM_DIR}
MG5_WORK_DIR=${TMPDIR}/${MG5_SLURM_DIR}
mkdir -p ${MG5_WORK_DIR}
mkdir -p ${MG5_OUTPUT}
cd ${MG5_WORK_DIR}

echo ">>>>> MG5_CONF >>>>> PROC_DIR >>>>> ${MG5_PROC_DIR}"
echo ">>>>> MG5_CONF >>>>> RUN_OPTS >>>>> ${MG5_RUN_OPTS}"
echo ">>>>> MG5_CONF >>>>> NUM_EVTS >>>>> ${MG5_NUM_EVTS}"
echo ">>>>> MG5_CONF >>>>> PROC_TAG >>>>> ${MG5_PROC_TAG}"
echo ">>>>> MG5_CONF >>>>> OUTP_DIR >>>>> ${MG5_OUTPUT}"
echo ">>>>> MG5_CONF >>>>> WORK_DIR >>>>> ${MG5_WORK_DIR}"

echo ">>>>> MG5_TIME >>>>> START    >>>>> `date`"

tar xvfz ${MG5_HOME}/sw/madgraph4gpu/MG5aMC/mg5amcnlo/${MG5_PROC_DIR}/run_01_gridpack.tar.gz

echo ">>>>> MG5_TIME >>>>> UNTAR    >>>>> `date`"

./run.sh ${MG5_RUN_OPTS} ${MG5_NUM_EVTS} ${SLURM_JOBID}

echo ">>>>> MG5_TIME >>>>> RUN      >>>>> `date`"

cp events.lhe.gz ${MG5_OUTPUT}

echo ">>>>> MG5_TIME >>>>> UPLOAD   >>>>> `date`"

tar cvfz . ${MG5_OUTPUT}/${MG5_SLURM_DIR}.tar.gz

echo ">>>>> MG5_TIME >>>>> END      >>>>> `date`"

