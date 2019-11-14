#!/bin/bash
for i in {1..255}
do
ping  -c  2 -i 0.2 -W 1  176.130.7.$i
if [ $? -eq 0 ];then
ssh 176.130.7.$i
else
echo   "不通"
fi
done
