#!/bin/bash
x=$RANDOM
while :
do
read -p "请输入一个数字" n
let a++
if [ $x -eq $n ];then
echo "$a次猜对了"
exit
elif [ $x -gt $n ];then
echo "猜小了"
else
echo "猜大了"
fi
done
