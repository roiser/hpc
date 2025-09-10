usershort=`echo ${USER} | cut -c 1-8`
while true; do
    clear
    squeue -u ${USER}
    echo
    squeue -u ${USER} | grep ${usershort} | wc -l
    echo
    date
    sleep 3
done
