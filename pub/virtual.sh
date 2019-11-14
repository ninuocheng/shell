#!/bin/bash
run=$(virsh list  |  awk '/running/{print $2}')
for i in $run
do
virsh destroy $i
done
s=$(virsh list --all | awk '/tedu_node/{print $2}')
cd  /var/lib/libvirt/images
for  n  in  $s
do
virsh undefine  $n
rm  -rf  ${n}.img
done
