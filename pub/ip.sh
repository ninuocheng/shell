#!/bin/bash
vm1() {
virsh start tedu_node${vm}
expect <<oppo
set timeout 35
spawn virsh console tedu_node${vm}
expect "localhost login:"  {send "root\r"}
expect "Password:" {send "123456\r"}
expect "#" {send "hostnamectl set-hostname $nm\r"}
expect "#"  {send "nmcli connection modify $wk ipv4.method manual ipv4.addresses ${ip}/24 connection.autoconnect yes\r"}
expect "#"  {send "nmcli connection up $wk\r"}
expect "#" {send "exit\r"}
oppo
echo
}
read -p "请输入要创建的虚拟机序号:"  vm
read -p "请输入网卡名:" wk
read -p "请输入IP地址:"  ip
read -p "请输入主机名:" nm
expect <<EOF
spawn clone-vm7
expect "Enter VM number:" {send "${vm}\r"}
expect "#" {send "exit\r"}
EOF
if [ ${vm}  -le 9 ];then
vm=0${vm}
vm1
elif
[ ${vm} -ge 10 -a  ${vm}  -lt  100 ];then
vm1
else
exit
fi
