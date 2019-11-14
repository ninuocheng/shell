#!/bin/bash
yum clean all
n=$(yum repolist 2> /dev/null | sed  -n '/^repolist/p' | awk '{print $2}')
if [ "$n" ==  0 ];then
echo "yum源不可用"  && exit
else
v=${n%,*}
[ "$v" !=  0 ]  &&  echo "yum源可用"
fi
b=$(ifconfig eth1 | awk '/inet/{print $2}')
yum -y install mariadb mariadb-server mariadb-devel
systemctl start mariadb
systemctl enable mariadb
read -p  "请输入之前单机版LNMP的一台网站服务器ip地址:"  a
ssh $a  "mysqldump wordpress >  wordpress.bak"
scp   $a:/root/wordpress.bak   /root
ssh $a "systemctl stop mariadb
systemctl disable mariadb"
#rpm -q expect
#if [ $? -eq 0 ];then
#echo  "expect已经安装"
#else
#echo  "expect未安装"
#yum -y install expect
#fi
mysql  <<EOF
create database wordpress character set utf8mb4;
grant all on wordpress.* to wordpress@'%' identified by 'wordpress';
flush privileges;
EOF
mysql wordpress < wordpress.bak
ssh $a "sed  -i  '32s/$a/$b/' /usr/local/nginx/html/wp-config.php"
systemctl restart   mariadb
