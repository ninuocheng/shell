#!/bin/bash
for i in  $(cat /opt/batchusers)
do
if [ -z $1 ];then
echo "Usage:/root/batchusers"
exit
elif [ ! -e $1 ];then
echo "Input file not found"
exit
else
useradd -s /bin/false $i
fi
done
