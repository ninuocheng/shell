#!/bin/bash
a=`seq 15`
for i in  $a
do
ping -c 2 -i 0.2 -W 1 172.25.0.$i >> /dev/null
if [ $? -eq 0 ];then
echo "Host 172.25.0.$i is up"
else
echo "Host 172.25.0.$i is down"
fi
done
