#!/bin/bash
d=/etc/haproxy/haproxy.cfg
#ssh  $1  "yum -y install haproxy"
#ssh  $1  "sed -i '63,86d'  $d"
 # echo  'listen wordpress *:80
 #   balance roundrobin
 #   server web1 192.168.2.11:80 check inter 2000 rise 2 fall 3
 #   server web2 192.168.2.12:80 check inter 2000 rise 2 fall 3
 #   server web3 192.168.2.13:80 check inter 2000 rise 2 fall 3' >> $d
#sed远程有困难
yum -y install haproxy
sed -i '63,86d'  $d
sed  -i  '$alisten wordpress *:80
          $abalance roundrobin
          $aserver web1 192.168.2.11:80 check inter 2000 rise 2 fall 3
          $aserver web2 192.168.2.12:80 check inter 2000 rise 2 fall 3
          $aserver web3 192.168.2.13:80 check inter 2000 rise 2 fall 3'   $d
systemctl start haproxy
systemctl enable haproxy"
