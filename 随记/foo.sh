#!/bin/bash
if [ -z $1 ];then
echo "/root/foo.sh redhat|fedora"
elif [ $1 == redhat ];then
echo "fedora"
elif [ $1 == fedora ];then
echo "redhat"
else
echo "/root/foo.sh redhat|fedora"
fi
