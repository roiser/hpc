grep "cp: cannot stat 'events.lhe.gz': No such file or directory" slurm-* | awk -F "/" '{ print $1 }' | awk -F ":" '{ print $1 }' | xargs grep "> run" | awk '{ print $NF }' | sort | uniq -c
