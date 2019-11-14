#!/bin/bash
yum clean all  &>   /dev/null
n=$(yum repolist  2> /dev/null | sed -n  '/^repolist:/p'  |  awk  '{print  $2}')
if [ "$n" ==  0  ];then
  echo "yum源不可用" && exit
else
v=${n%,*}
[ "$v" !=  0  ]  &&  echo "yum源可用"
fi
conf=/etc/named.conf
zone=/var/named/lab.com.zone
yum   -y install bind  bind-chroot
sed  -i  '20,49d'   $conf
sed  -i  '12,25!d'  $conf
sed  -i   '5,7d'  $conf
sed  -i   '/v6/d'  $conf
sed  -i  '/127/s/127.0.0.1/any/'   $conf
sed  -i  '/localhost/s/localhost/any/'  $conf
sed  -i  '/zone/s/./lab.com/'  $conf
sed  -i   '/type/s/hint/master/'  $conf
sed  -i   '/named.ca/s/named.ca/lab.com.zone/'  $conf
cp  -p  /var/named/named.localhost  /var/named/lab.com.zone
sed  -i  '8,10d'   $zone
sed  -i   '$a@                  NS    dns.lab.com.\
dns                A      192.168.4.5\
www                A      192.168.4.5'   $zone
systemctl start named
systemctl enable  named
