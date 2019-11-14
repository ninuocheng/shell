#!/bin/bash
dir=/media/cdrom
if [ -d $dir ];then
exit
else
mkdir -p $dir
fi

