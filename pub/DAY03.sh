#!/bin/bash
yum clean all  &>  /dev/null
n=$(yum repolist  2> /dev/null | sed -n  '/^repolist:/p'  |  awk  '{print  $2}')
if [ "$n" ==  0  ];then
  echo "yum源不可用" && exit
else
v=${n%,*}
[ "$v" !=  0  ]  &&  echo "yum源可用"
fi
read  -p  "请输入web1服务器ip地址(LNP):"  x
read  -p  "请输入web2服务器ip地址(LNP):"  y
read  -p  "请输入web3服务器ip地址(LNP):"  u
read  -p  "请输入nfs服务器ip地址:"  z
read  -p  "请输入haproxy服务器ip地址:"  h
read  -p "请输入和虚拟机同网段的真机ip地址:"  a
for i in  $y  $u 
do
ssh  $i  "yum -y install gcc pcre-devel openssl-devel
scp  $a:/linux-soft/02/lnmp_soft/nginx-1.12.2.tar.gz  /root
tar -xf  nginx-1.12.2.tar.gz
cd nginx-1.12.2
./configure --with-http_ssl_module  --with-http_stub_status_module
make && make install
yum -y install php php-fpm  php-mysql mariadb-devel
sed   -i  '65,71s/#//'  /usr/local/nginx/conf/nginx.conf
sed  -i '69s/^/#/'  /usr/local/nginx/conf/nginx.conf
sed  -i '70s/_params/.conf/'  /usr/local/nginx/conf/nginx.conf
sed  -i  '$a/usr/local/nginx/sbin/nginx'  /etc/rc.local
chmod +x  /etc/rc.local
/usr/local/nginx/sbin/nginx
systemctl start php-fpm
systemctl enable php-fpm"
done
u=${z%.*}
ssh $z "yum -y install nfs-utils
mkdir /web_share
sed  -i  '$a/web_share  ${u}.0/24(rw,no_root_squash)'  /etc/exports
systemctl restart rpcbind  nfs
systemctl enable rpcbind  nfs"
ssh  $x "cd /usr/local/nginx
tar  -czpf html.tar.gz  html/
scp  html html.tar.gz  $z:/web_share/"
ssh  $z "cd /web_share/
tar -xf html.tar.gz"
ssh $x  "rm -rf /usr/local/nginx/html/*
yum -y install nfs-utils
sed -i '$a$z:/web_share/html  /usr/local/nginx/html/  nfs  defaults 0 0'  /etc/fstab
mount  -a"
for j in  $y  $u
do
ssh  $j "yum -y install nfs-utils
sed -i '$a$z:/web_share/html  /usr/local/nginx/html/  nfs  defaults 0 0'  /etc/fstab
mount -a"
done
ssh $h  "yum -y install haproxy
d=/etc/haproxy/haproxy.cfg
sed -i '63,86d'  $d
echo  'listen wordpress *:80
  balance roundrobin
  server web1 192.168.2.11:80 check inter 2000 rise 2 fall 3
  server web2 192.168.2.12:80 check inter 2000 rise 2 fall 3
  server web3 192.168.2.13:80 check inter 2000 rise 2 fall 3' >> $d
systemctl start haproxy
systemctl enable haproxy"
#yum -y install bind bind-chroot
#sed  -i  '/^\/\//d' /etc/named.conf
#sed  -i  '20,49d'   /etc/named.conf

