#!/bin/bash
ip=$(ifconfig eth0 |awk '/inet/{print $2}')
num=`ifconfig eth0 |awk '/inet/{print $2}' |awk -F[.] '{print $4}'`
redis_conf=/etc/redis/63${num}.conf
start_conf=/etc/init.d/redis_63$num
rpm -q gcc || yum -y install gcc
tar -xf redis-4.0.8.tar.gz
cd redis-4.0.8
make && make install
rpm -q expect || yum -y install expect
expect <<EOF
spawn ./utils/install_server.sh
expect "Please select the redis port for this instance:" {send "63$num\r"}
expect "Please select the redis config file name" {send "\r"}
expect "Please select the redis log file name" {send "\r"}
expect "Please select the data directory for this instance" {send "\r"}
expect "Please select the redis executable path" {send "\r"}
expect "Is this ok? " {send "\r"}
expect  "#"  {send "exit\r"}
EOF
sed -i "/^bind/s/127.0.0.1/$ip/" $redis_conf
sed -i "/-p/s/-p/-h $ip -p/" $start_conf
$start_conf restart
