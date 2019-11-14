#!/bin/bash
for i  in  $(cat /opt/users.txt)
do
useradd $i &> /dev/null
echo 123456 | passwd --stdin $i &> /dev/null
done
