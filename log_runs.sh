grep "> run" slurm-* | awk '{ print $NF }' | sort | uniq -c
