#!/bin/bash
yum clean all  &>  /dev/null
n=$(yum repolist  2> /dev/null | sed -n  '/^repolist:/p'  |  awk  '{print  $2}')
if [ "$n" ==  0  ];then
  echo "yum源不可用" && exit
else
v=${n%,*}
[ "$v" !=  0  ]  &&  echo "yum源可用"
fi
scp  192.168.4.254:/linux-soft/03/mysql/mysql-5.7.17.tar  /root
tar -xf mysql-5.7.17.tar
yum -y install mysql-community-*.rpm
systemctl start mysqld
systemctl enable mysqld
pass=$(sed  -n  '/A temporary password/p'  /var/log/mysqld.log  | awk  '{print $NF}')
mysql -uroot  -p$pass  --connect-expired-password  -e "alter user root@"localhost" identified by  '123qqq...A'"
sed  -ri '/\[mysqld\]/avalidate_password_policy=0\nvalidate_password_length=6'  /etc/my.cnf
systemctl restart mysqld
