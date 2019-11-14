#!/bin/bash
for i in {1..10}
do
useradd user$i 2>> /root/user.log
echo "123456" | passwd --stdin  user$i > /dev/null
done
