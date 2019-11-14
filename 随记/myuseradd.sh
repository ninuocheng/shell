#!/bin/bash
useradd  $1
echo  $2  | passwd --stdin  $1
echo $#
echo "用户名是$1,密码是$2"
