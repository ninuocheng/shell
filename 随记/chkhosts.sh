#!/bin/bash
for i in `seq 254`
do
ping  -c 2 -i 0.1 -W 192.168.4.$i &> /dev/null
if [ $? -eq 0 ];then
echo "Host 192.168.4.$i is up."
else
echo "Host 192.168.4.$i is down."
fi
done

