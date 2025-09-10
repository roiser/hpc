run=$1

if [[ ${run} == "" ]]; then
    echo "usage: ${0} <run>, e.g. ${0} run42"
    exit 1
fi

mkdir -p logs/${run}
for f in `grep "> ${run}" slurm-*.out | awk -F ":" '{ print $1 }'`; do
    echo $f;
    mv $f logs/${run}
done
