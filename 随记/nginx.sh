#!/bin/bash
yum -y install gcc pcre-devel zlib-devel
tar -xf nginx-1.10.3.tar.gz
cd nginx-1.10.3
./configure
make && make install
