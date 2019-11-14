#!/bin/bash
#read -p  "请输入单机版LNMP服务器ip地址"  s
yum clean all  &>  /dev/null
n=$(yum repolist  2> /dev/null | sed -n  '/^repolist:/p'  |  awk  '{print  $2}')
if [ "$n" ==  0  ];then
  echo "yum源不可用" && exit
else
v=${n%,*}
[ "$v" !=  0  ]  &&  echo "yum源可用"
fi
ssh-keygen  -f  /root/.ssh/id_rsa  -N ''
ssh-copy-id  192.168.2.254
yum -y install gcc pcre-devel openssl-devel
yum -y install mariadb mariadb-server mariadb-devel
yum -y install php php-fpm php-mysql
useradd -s /sbin/nologin  nginx
scp  192.168.2.254:/linux-soft/02/lnmp_soft/nginx-1.12.2.tar.gz  /root
tar -xf  nginx-1.12.2.tar.gz
cd nginx-1.12.2
./configure  --user=nginx  --group=nginx  --with-http_ssl_module  --with-http_stub_status_module 
make && make  install
/usr/local/nginx/sbin/nginx
systemctl start mariadb  php-fpm
systemctl enable mariadb php-fpm
sed  -i  '$a/usr/local/nginx/sbin/nginx'  /etc/rc.local
chmod +x  /etc/rc.local
sed   -i  '65,71s/#//'  /usr/local/nginx/conf/nginx.conf
sed  -i '69s/^/#/'  /usr/local/nginx/conf/nginx.conf
sed  -i '70s/_params/.conf/'  /usr/local/nginx/conf/nginx.conf
sed -i '45s/index/index index.php/'  /usr/local/nginx/conf/nginx.conf
rpm  -q  expect
if [ $? -eq  0 ];then
echo "expect 已经安装"
else
echo "expect未安装"
yum -y install expect
fi
mysql <<EOF
create database wordpress character set utf8mb4;
grant all on wordpress.* to wordpress@'192.168.2.11' identified by  'wordpress';
flush privileges;
EOF
rpm -q unzip
if [ $? -eq  0  ];then
echo "unzip已经安装"
else
echo  "unzip未安装"
yum -y install unzip
fi
scp  192.168.2.254:/linux-soft/02/lnmp_soft/wordpress.zip  /root/
unzip /root/wordpress.zip  -d  /root
cd  /root/wordpress
tar -xf wordpress-5.0.3-zh_CN.tar.gz
cp -r wordpress/*  /usr/local/nginx/html/
chown  -R  apache.apache  /usr/local/nginx/html/
systemctl restart mariadb  php-fpm
/usr/local/nginx/sbin/nginx  -s reload
