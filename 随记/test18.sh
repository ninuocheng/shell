#!/bin/bash
a=0
b=0
for i in `seq 15`
do
ping -c 2 -i 0.1 -W 1 172.25.0.$i &> /dev/null
if [ $? == 0 ]
then
echo "172.25.0.$i通了"
let a++
else
echo "172.25.0.$i不通"
let b++
fi
done
echo "$a台通了,$b台不通"
