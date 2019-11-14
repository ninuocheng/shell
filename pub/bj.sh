#!/bin/bash
cd  /var/lib/libvirt/images/jpg
while :
do
for i in  $(ls  /var/lib/libvirt/images/jpg)
do
sed  -ri "/^picture-uri/s/[A-Z]+.jpg/$i/"   /etc/dconf/db/local.d/00-background
dconf update
sleep  300
done
sleep  300
done  &
