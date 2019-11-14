sed基本用法
sed(Stream Editor),流式编辑器
非交互,基于模式匹配过滤及修改文本
逐行处理,并将结果输出到屏幕
可实现对文本的输出、删除、替换、复制、剪切、导入、导出等各种操作
主要用法
格式1    前置命令  | sed  选项   '编辑指令'
格式2    sed     选项      '编辑指令' ([定址符]处理动作)   文件
[root@server0 opt]# grep '^bin'  /etc/passwd
bin:x:1:1:bin:/bin:/sbin/nologin
[root@server0 opt]# sed -n  '/^bin/p'  /etc/passwd
bin:x:1:1:bin:/bin:/sbin/nologin
常见命令选项
-n      屏蔽默认输出(全部文本)
-i      直接修改文件内容
-r      启用扩展的正则表达式,若与其它选项一起使用.应作为首个选项
条件,可以是行号或者/正则/
行号可以使用单个数字表示单行
或者3,5表示连续的多行(第三行至第五行)
省略条件,则默认逐行处理全部文本
匹配正则时,需要使用//
[root@server0 opt]#sed -n 'p'  /etc/passwd          默认逐行处理输出全部
[root@server0 opt]#sed -n '2,4p'  /etc/passwd       输出第2-4行   
[root@server0 opt]#sed -n '/root/p'  /etc/passwd    输出包含root的行
基本的处理动作
常用动作指令
p    打印行     2,4p    输出第2至第4行   2p;4p   输出第2行和第4行
d    删除行     2,4d    删除第2至第4行
s    字符串替换   s/old/new/   将每行的第一个old替换为new
                s/old/new/3  将每行的第三个old替换为new
                s/old/new/g  将每行的所有old都替换为new
替换操作的分隔"/"可改用其它字符,如#、&等,便于修改文件路径
输出文本的示例
sed     -n     'p'         a.txt         默认逐行处理文本输出全部,等同于cat  a.txt
sed     -n     '4p'        a.txt         输出第四行
sed     -n     '4,7p'      a.txt         输出第4-7行
sed     -n     '4,+10p'    a.txt         输出第四行及其后的十行
sed     -n     '/^bin/p'   a.txt         输出以bin开头的行
sed     -n     '$='        a.txt         输出文件的行的数量
sed     -n     '$p'        a.txt         输出文件的最后一行
删除文本的示例
sed        '3,5d'          a.txt         删除第三行至第五行
sed        '/xml/d'        a.txt         删除所有包含xml的行
sed        '/xml/!d'       a.txt         删除不包含xml的行,!符号表示取反
sed        '/^install/d'   a.txt         删除以install开头的行
sed        '$d'            a.txt         删除文件的最后一行
sed        '/^$/d'         a.txt         删除所有空行
此例中只作输出,不更改原文件(若需要更改,应添加选项-i)
替换文本的示例
sed        's/xml/XML/'            a.txt     默认将每行中的第一个xml替换为XML
sed        's/xml/XML/3'           a.txt     将每行中的第三个xml替换为XML
sed        's/xml/XML/g'           a.txt     将每行中的所有xml替换为XML
sed        's/xml//g'              a.txt     将每行中的所有xml都删除(替换为空串)
sed        '4,7s/^/#/'             a.txt     将第4-7行都注释掉(行首加#号)
sed        's/^#an/an/'            a.txt     解除以#an开头的行的注释(去除行首的#号)
此例中只作输出,不更改原文件(若需要更改,应添加选项-i)
sed的文本块处理动作
i   行前插入文本    2iYY    在第2行之前添加文本行"YY"   4,7iYY      在第4-7行的每一行前添加文本行
a   行后插入文本    2aYY    在第2行之后添加文本           /^XX/aYY     在以XX开头的行之后添加文本  
c   替换当前行      2cYY    将第2行的内容修改为"YY"
文本块处理的应用
[root@server0 opt]# sed -n p m.txt
1111111111  Tarena
222 IT  Group
[root@server0 opt]# sed '2iXX'  m.txt   插入到第2行前
1111111111  Tarena
XX
222 IT  Group
[root@server0 opt]# sed '2aXX' m.txt    插入到第2行后
1111111111  Tarena
222 IT  Group
XX
[root@server0 opt]# sed '2cXX' m.txt     替换指定行
1111111111  Tarena
XX
处理多行文本
修改后的文本有多行时
以换行符\n分隔
或者使用\强制换行
[root@server0 opt]# sed -n p a.txt
xmlxmlxml
[root@server0 opt]# sed  'axx\
> bb\
> cc\
> dd'  a.txt
xmlxmlxml
xx
bb
cc
dd
[root@server0 opt]# sed  'aqq\nww\ee\nee'  a.txt
xmlxmlxml
qq
wwee
ee
sed  -ri  '/^IPADDR/s/192.168.2.(.*)/172.16.0.\1/' ifcfg-eth1



