#!/bin/bash
k=/etc/keepalived//etc/keepalived/keepalived.conf
yum -y install keepalived
sed  -i  '35,$d'  $k
sed  -i  '/192.168/d'  $k
sed  -i  '$a192.168.4.80'  $k
sed  -i  '13,16d'  $k
sed  -i   '12avrrp_iptables' $k
systemctl start keepalived
systemctl enable keepalived

