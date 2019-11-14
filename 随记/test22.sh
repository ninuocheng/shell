#!/bin/bash
for  i in  `seq 10`
do
read -p "请输入积分" n
if [ $n -ge 90 ];then
echo "神功绝世"
elif [ $n -ge 80 ] && [ $n -lt 90 ];then
echo "登峰造极"
elif [ $n -ge 70 ] && [ $n -lt 80 ];then
echo "炉火纯青"
elif [ $n -ge 60 ] && [ $n -lt 70 ];then
echo "略有小成"
else
echo "初学乍练"
fi
done
