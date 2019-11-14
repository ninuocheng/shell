#!/bin/bash
ssh-keygen  -f  /root/.ssh/id_rsa  -N ''
for  z  in   1
do
read  -p   "请输入和虚拟机同网段的真机ip地址:"  zj
q=$zj
ssh-copy-id  $q
ssh $q "[ -d  /var/ftp/ceph ] || mkdir  /var/ftp/ceph"
#ssh $q "mount  /linux-soft/02/ceph10.iso  /var/ftp/ceph"
#ssh $q "echo  "/linux-soft/02/ceph10.iso  /var/ftp/ceph iso9660 defaults 0 0" >> /etc/fstab
#echo  "/var/lib/libvirt/images/iso/CentOS7-1804.iso  /var/www/html/dvd  iso9660 defaults 0 0"  >>  /etc/fstab"
#ssh $q  "sed  -i  '$a/linux-soft/02/ceph10.iso  /var/ftp/ceph iso9660 defaults 0 0'  /etc/fstab"
#mount -a
done
for i  in  `seq  3`
do
read -p  "请输入3台存储集群虚拟机主机名:"  host
read -p  "请输入3台对应的ip地址:"  addr
if [ $i -eq 1 ];then
a=$host
b=$addr
elif [ $i -eq 2 ];then
c=$host
d=$addr
else
e=$host
f=$addr
fi
done
read  -p  "请输入新建的一台MDS虚拟机:" md
read  -p  "请输入对应的ip地址:" mz
g=$md
h=$mz
read  -p  "请输入新建的一台RGW虚拟机:" rg
read  -p  "请输入对应的ip地址:"  rz
o=$rg
s=$rz
read  -p  "请输入客户端虚拟机主机名:" kh
read  -p  "请输入客户端对应的ip地址:" dz
u=$kh
w=$dz
#ip=$(ifconfig eth0 | awk  '/inet/{print $2}')
#host=$(echo $HOSTNAME)
sed   -i   '/^server/s/gateway/192.168.4.254/'  /etc/chrony.conf
#方法1
#sed  -i  '$a'$b'   '$a' 
#$a'$d'         '$c'
#$a'$f'         '$e'
#$a'$h'         '$g'
#$a'$s'         '$o'
#$a'$w'         '$u''     /etc/hosts
#方法2
sed  -i  '$a'$b'   '$a'\ 
'$d'         '$c'\
'$f'         '$e'\
'$h'         '$g'\
'$s'         '$o'\
'$w'         '$u''     /etc/hosts
y=/etc/yum.repos.d/local.repo
echo "[CentOS7]
name=CentOS 7
baseurl=http://${zj}/dvd/
enabled=1
gpgcheck=0
[mon]
name=mon
baseurl=ftp://${zj}/ceph/MON
enabled=1
gpgcheck=0
[osd]
name=osd
baseurl=ftp://${zj}/ceph/OSD
enabled=1
gpgcheck=0
[tools]
name=tools
baseurl=ftp://${zj}/ceph/Tools
enabled=1
gpgcheck=0"  >  $y
yum clean all  &>  /dev/null
n=$(yum repolist  2> /dev/null | sed -n  '/^repolist:/p'  |  awk  '{print  $2}')
if [ "$n" ==  0  ];then
  echo "yum源不可用" && exit
else
v=${n%,*}
[ "$v" !=  0  ]  &&  echo "yum源可用"
fi
sed  -i  ''/^server/s/gateway/${zj}/'' /etc/chrony.conf
yum  -y install ceph-deploy
mkdir ceph-cluster
cd ceph-cluster
for j in $b $d $f $h $w $s
do
ssh-copy-id  $j
scp  $y  $j:/etc/yum.repos.d/
scp /etc/{chrony.conf,hosts}  $j:/etc/
ssh $j "systemctl restart  chronyd"
done
for k in $b $d $f
do
ssh $k  "systemctl restart  chronyd ; yum  -y install ceph-mon ceph-osd ceph-radosgw
parted  /dev/vdb  mklabel gpt
parted  /dev/vdb  mkpart primary 1 50%
parted  /dev/vdb  mkpart primary 50% 100%"
done
for  i in $a $c $e
do
ssh $i "chown ceph:ceph /dev/vdb*
echo  'ENV{DEVNAME}=="'"'/dev/vdb1'"'",OWNER="'"'ceph'"'",GROUP="'"'ceph'"'"
ENV{DEVNAME}=="'"'/dev/vdb2'"'",OWNER="'"'ceph'"'",GROUP="'"'ceph'"'"' >  /etc/udev/rules.d/70-vdb.rules"
done
ceph-deploy new  $a $c $e
ceph-deploy mon create-initial
for x in $a $c $e
do
#ssh $x  "echo  "ENV{DEVNAME}=="/dev/vdb1",OWNER="ceph",GROUP="ceph"
#ENV{DEVNAME}=="/dev/vdb2",OWNER="ceph",GROUP="ceph"" >  /etc/udev/rules.d/70-vdb.rules
ceph-deploy disk zap ${x}:vdc ${x}:vdd
y=/etc/yum.repos.d/local.repo
echo "[CentOS7]
name=CentOS 7
baseurl=http://${zj}/dvd/
enabled=1
gpgcheck=0
[mon]
name=mon
baseurl=ftp://${zj}/ceph/MON
enabled=1
gpgcheck=0
[osd]
name=osd
baseurl=ftp://${zj}/ceph/OSD
enabled=1
gpgcheck=0
[tools]
name=tools
baseurl=ftp://${zj}/ceph/Tools
enabled=1
gpgcheck=0"  >  $y
yum clean all  &>  /dev/null
n=$(yum repolist  2> /dev/null | sed -n  '/^repolist:/p'  |  awk  '{print  $2}')
if [ "$n" ==  0  ];then
  echo "yum源不可用" && exit
else
v=${n%,*}
[ "$v" !=  0  ]  &&  echo "yum源可用"
fi
sed  -i  ''/^server/s/gateway/${zj}/'' /etc/chrony.conf
yum  -y install ceph-deploy
mkdir ceph-cluster
cd ceph-cluster
for j in $b $d $f $h $w $s
do
ssh-copy-id  $j
scp  $y  $j:/etc/yum.repos.d/
scp /etc/{chrony.conf,hosts}  $j:/etc/
ssh $j "systemctl restart  chronyd"
done
for k in $b $d $f
do
ssh $k  "systemctl restart  chronyd ; yum  -y install ceph-mon ceph-osd ceph-radosgw
parted  /dev/vdb  mklabel gpt
parted  /dev/vdb  mkpart primary 1 50%
parted  /dev/vdb  mkpart primary 50% 100%"
done
for  i in $a $c $e
do
ssh $i "chown ceph:ceph /dev/vdb*
echo  'ENV{DEVNAME}=="'"'/dev/vdb1'"'",OWNER="'"'ceph'"'",GROUP="'"'ceph'"'"
ENV{DEVNAME}=="'"'/dev/vdb2'"'",OWNER="'"'ceph'"'",GROUP="'"'ceph'"'"' >  /etc/udev/rules.d/70-vdb.rules"
done
ceph-deploy new  $a $c $e
ceph-deploy mon create-initial
for x in $a $c $e
do
#ssh $x  "echo  "ENV{DEVNAME}=="/dev/vdb1",OWNER="ceph",GROUP="ceph"
#ENV{DEVNAME}=="/dev/vdb2",OWNER="ceph",GROUP="ceph"" >  /etc/udev/rules.d/70-vdb.rules
ceph-deploy disk zap ${x}:vdc ${x}:vdd
ceph-deploy osd create ${x}:vdc:/dev/vdb1 ${x}:vdd:/dev/vdb2
done
A=$(ceph -s  |  awk  -F_  '/health/{print $2}')
sleep  5
A=$(ceph -s  |  awk  -F_  '/health/{print $2}')
sleep  5
A=$(ceph -s  |  awk  -F_  '/health/{print $2}')
[ $A == "OK" ]  ||  exit
ssh $h "yum -y install ceph-mds"
ceph-deploy mds create $g
ssh $g "ceph osd pool create cephfs_data 128
ceph osd pool create cephfs_metadata 128
ceph fs new myfs1 cephfs_metadata ceph_data"
ssh $o "yum -y install ceph-radosgw"
ceph-deploy rgw create $o
