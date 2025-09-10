log=$1

if [[ ${log} == "" ]]; then
    echo "usage: ${0} <logfile>, e.g. ${0} slurm-1234578.out"
    exit 1
fi

grep ">>>>>" ${log} 
