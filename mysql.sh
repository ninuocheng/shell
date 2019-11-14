Shell脚本中执行sql语句，操作mysql数据库:
1.在shell脚本以EOF开始，以EOF结束:

#!/bin/bash

mysql -uroot -proot <<EOF  （EOF 是mysql开始的符号）

show databases;

use test;

insert into teacher(id,name) value(1,"wl");

insert into student(id,name) values(1,"renyuz");

EOF  （EOF 是mysql结束的符号）

2.将SQL语句直接嵌入到shell脚本文件中：

mysql -uroot -p123456 -e "

tee /tmp/temp.log

drop database if exists tempdb;

create database tempdb;

use tempdb

create table if not exists tb_tmp(id smallint,val varchar(20));

insert into tb_tmp values (1,'jack'),(2,'robin'),(3,'mark');

select * from tb_tmp;

notee

quit"

在mysql命令行中，使用tee命令，可以记录语句和输出到指定文件。在debugging时会很有用。

每执行一条语句，mysql都会讲执行结果刷新到指定文件。Tee功能只在交互模式生效。

使用notee命令来关闭日志记录。

作者：徐小麦
链接：https://www.jianshu.com/p/31b2f026c898
来源：简书
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
