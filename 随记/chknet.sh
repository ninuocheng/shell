#!/bin/bash
i=1
while :
do
ip="192.168.4.$i"
ping -c 1 -i 0.1 -W 1 $ip &> /dev/null
if [ $? -eq 0 ];then
echo "Host $ip is up."
else
echo "Host $ip is down."
fi
done
