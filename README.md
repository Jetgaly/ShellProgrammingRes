#### shell脚本文件的执行

1. source filename or . filename
   不创建subshell，在当前shell环境下读取并执行filename中的命令，相当于顺序执行filename里面的命令

2. bash filename or ./filename
   创建subshell，在当前bash环境下再新建一个子shell执行filename中的命令
     子shell只能继承父shell通过export导出的变量，而未导出的变量不会被继承，所以子shell无法使用

3. export变量只在**当前的shell(BASH)或其子shell(BASH)**下是有效的,在关闭shell后失效，再打开新shell时就没有这个变量，需要使用的话还需要重新定义

```bash
sh hello.sh
bash hello.sh #开一个新shell运行
source hello.sh #在当前shell运行
. hello.sh #在当前shell运行
./hello.sh #开一个子shell来运行
```

```bash
jjet@jet:~/scripts$ ll
total 12
drwxrwxr-x 2 jjet jjet 4096 Apr 15 21:35 ./
drwxr-x--- 5 jjet jjet 4096 Apr 15 21:35 ../
-rw-rw-r-- 1 jjet jjet   31 Apr 15 21:33 hello.sh
jjet@jet:~/scripts$ chmod u+x hello.sh
jjet@jet:~/scripts$ ll
total 12
drwxrwxr-x 2 jjet jjet 4096 Apr 15 21:35 ./
drwxr-x--- 5 jjet jjet 4096 Apr 15 21:35 ../
-rwxrw-r-- 1 jjet jjet   31 Apr 15 21:33 hello.sh*
jjet@jet:~/scripts$ ./hello.sh
hello,world
```

```bash
env #查看环境变量
```

set 显示当前shell的变量（本地变量），包括当前用户的变量（ 环境变量）

env 显示当前用户的变量 (环境变量）

export 显示当前导出成用户变量的shell变量 (环境变量）



#### 定义变量

shell中的变量默认为字符串

=前后不能加空格

如果要加空格就要用' '  / " "

```bash
jjet@jet:~/scripts$ a=2
jjet@jet:~/scripts$ echo $a
2
jjet@jet:~/scripts$ a='hello world'
jjet@jet:~/scripts$ echo $a
hello world
jjet@jet:~/scripts$ a="hello today"
jjet@jet:~/scripts$ echo $a
hello today
```

提升为全局变量用export valName

Linux export 命令用于设置或显示环境变量。

在 shell 中执行程序时，shell 会提供一组环境变量。export 可新增，修改或删除环境变量，供后续执行的程序使用。export 的效力仅限于该次登陆操作。

更改只在当前shell有效（在子shell里更改val不会影响父shell）

```bash
jjet@jet:~/scripts$ ps -f
UID          PID    PPID  C STIME TTY          TIME CMD
jjet         350     349  0 09:47 pts/0    00:00:00 -bash
jjet         624     350  0 10:04 pts/0    00:00:00 ps -f
jjet@jet:~/scripts$ echo $a
hello today
jjet@jet:~/scripts$ export a
jjet@jet:~/scripts$ bash
jjet@jet:~/scripts$ ps -f
UID          PID    PPID  C STIME TTY          TIME CMD
jjet         350     349  0 09:47 pts/0    00:00:00 -bash
jjet         625     350  0 10:04 pts/0    00:00:00 bash
jjet         888     625  0 10:04 pts/0    00:00:00 ps -f
jjet@jet:~/scripts$ echo $a
hello today
jjet@jet:~/scripts$ a='hello linux'
jjet@jet:~/scripts$ echo $a
hello linux
jjet@jet:~/scripts$ exit
exit
jjet@jet:~/scripts$ ps -f
UID          PID    PPID  C STIME TTY          TIME CMD
jjet         350     349  0 09:47 pts/0    00:00:00 -bash
jjet        1038     350  0 10:05 pts/0    00:00:00 ps -f
jjet@jet:~/scripts$ echo $a
hello today
```



new_val为局部变量，所以在子shell中会找不到（./hello.sh）

```bash
jjet@jet:~/scripts$ new_val='hello,new_val'
jjet@jet:~/scripts$ ./hello.sh
hello,world
hello today

jjet@jet:~/scripts$ source hello.sh
hello,world
hello today
hello,new_val
jjet@jet:~/scripts$ . hello.sh
hello,world
hello today
hello,new_val
```



readonly定义只读变量

```bash
jjet@jet:~/scripts$ readonly read_val='onlyRead'
jjet@jet:~/scripts$ read_val='Read'
-bash: read_val: readonly variable
```



unset撤销变量（readonly变量不能撤销）

```bash
hello today
jjet@jet:~/scripts$ b='test'
jjet@jet:~/scripts$ echo $b
test
jjet@jet:~/scripts$ unset b
jjet@jet:~/scripts$ echo $b

jjet@jet:~/scripts$
```

#### 参数传递

$0为脚本名称 . 或者 source 为解释器名称     ./ 为./scriptName 

\$1,\$2......\$9   从10起要{ }     \${10}

\$#为参数个数（\$0不算）

\$*为所有参数看成一个整体

\$@为把每个参数区别对待

\$?用于获取上一个shell命令的退出状态码，或者是函数的返回值

```bash
  echo "hello"
  echo $?        # 上一条肯定执行成功，这就会得到0
```

\$$当前shell的id

```bash
jjet@jet:~/scripts$ echo $$
350
```

```shell
#!/bin/bash
echo '=============$n============='#''单引号不会吧$当参数处理
echo script name: $0
echo first parameter: $1
echo second parameter: $2
```

####  变量运算

expr 命令 要空格

\\*要加 \ * 转义

```bash
jjet@jet:~/scripts$ expr 1 + 2
3
```

```bash
jjet@jet:~/scripts$ a=$[1+2]
jjet@jet:~/scripts$ echo $a
3
jjet@jet:~/scripts$ a=$((5*2))
jjet@jet:~/scripts$ echo $a
10
jjet@jet:~/scripts$ a=$(expr 1 + 2)
jjet@jet:~/scripts$ echo $a
3
jjet@jet:~/scripts$ a=`expr 1 + 2`
jjet@jet:~/scripts$ echo $a
3
```

#### 条件判断

test condition

[ condition ] 注意空格

```bash
jjet@jet:~/scripts$ test $a = 1 #判断a的值是否为1  =也要空格
jjet@jet:~/scripts$ echo $?
1
jjet@jet:~/scripts$ echo $a
3
jjet@jet:~/scripts$ [ $a = 3 ]# =也要空格
jjet@jet:~/scripts$ echo $?
0
jjet@jet:~/scripts$ [ 2 -eq 2 ]
jjet@jet:~/scripts$ echo $?
0
jjet@jet:~/scripts$ touch test
jjet@jet:~/scripts$ [ -r hello.sh ]
jjet@jet:~/scripts$ echo $?
0
jjet@jet:~/scripts$ [ -x hello.sh ]
jjet@jet:~/scripts$ echo $?
0
jjet@jet:~/scripts$ [ -x test ]
jjet@jet:~/scripts$ echo $?
1
```

按照数值比较 -eq  -ne  -gt  -lt  -ge  -le 

文件权限比较 -w  -r  -x

文件类型比较 -e  -f   -d 

-e 为存在



类似三元运算符

c1 && c2 || c3

#### 流程控制

if

```bash
#!/bin/bash  //指定脚本解释器，不是注释
#1
if [ $1 -gt 18 ];then
        echo ok
fi

#2
if [ $1 -gt 18 ]
then
        echo ok
fi

#3
if [ $1 -gt 18 ]
then
        echo ok
elif [ $1 -gt 0 ] && [ $1 -le 18 ]
then
        echo not ok
else
        echo age illegal
fi
~                                                                                                                   
```

case

```bash
#/bin/bash

case $1 in
1)
        echo one
;;
2)
        echo two
;;#break
*)#default
        echo else
;;
esac
~            
```

for

```bash
#在Bash脚本中，未初始化的变量在算术运算中会被视为0。因此，即使没有显式初始化sum，循环仍能正确累加
#!/bin/bash

for (( i=0; i < 100; i++ ))
do
        sum=$[ $sum + $i ]
done
echo $sum


for i in {0..99}
do
        sum2=$[ $sum2 + $i ]
done
echo $sum2
```

当 $* 和 $@ 不被双引号`" "`包围时，它们之间没有任何区别，都是将接收到的每个参数看做一份数据，彼此之间以空格来分隔。

但是当它们被双引号`" "`包含时，就会有区别了：

- `"$*"`会将所有的参数从整体上看做一份数据，而不是把每个参数都看做一份数据。
- `"$@"`仍然将每个参数都看作一份数据，彼此之间是独立的。

```bash
#!/bin/bash

echo '============$*============'
for para in "$*"
do
        echo $para
done

echo '============$@============'
for para in "$@"
do
        echo $para
done
```

while

```bash
#!/bin/bash
i=1
sum=0
while [ $i -le 100 ]
do
#       sum=$[ $i + $sum ]
#       i=$[$i+1]
        let sum+=i
        let i++
done
echo $sum
```

#### read读取控制台输入

```bash
#!/bin/bash

read -t 10 -p "输入你的姓名：" name #-t表示等待10s,10s不输入继续执行,不加则一直等待输入,-p则是输入提示信息
echo "welcome, $name"
```

#### 函数

```bash
#!/bin/bash
filename="$1"_log_$(date +%s)#调用date函数 %s为参数 $()取date +%s的值
echo $filename
```

basename

```bash
#!/bin/bash
filename=$(basename $0)                                                                                                 echo $filename 
```

dirname

```shell
#!/bin/bash
cd $(dirname $0)#. source 的方式执行不行,因为$0是shell的名称
filename=$(pwd)
echo $filename
```

function

$?可以访问返回值

如果没写return，就是函数最后一条语句的值

return只能返回0-255

```shell
#!/bin/bash

function add()
{
        s=$[$1+$2]
        echo "sum = $s"
}

read -p "first num : " a
read -p "second num : " b

add $a $b
```

```shell
#!/bin/bash

function add()
{
        s=$[$1+$2]
        return $s
}

read -p "first num : " a
read -p "second num : " b

add $a $b
echo "sum = $?"
```

优化后

```shell
#!/bin/bash

function add()
{
        s=$[$1+$2]
        echo $s
}

read -p "first num : " a
read -p "second num : " b

sum=$(add $a $b)
echo $sum
```

#### else

Linux **crontab** 是 Linux 系统中用于设置周期性被执行的指令的命令。

当安装完成操作系统之后，默认便会启动此任务调度命令。

**crond** 命令每分钟会定期检查是否有要执行的工作，如果有要执行的工作便会自动执行该工作。

**注意：**新创建的 cron 任务，不会马上执行，至少要过 2 分钟后才可以，当然你可以重启 cron 来马上执行。

查看当前用户的 crontab 文件：

```bash
crontab -l
```

编辑当前用户的 crontab 文件：

```bash
crontab -e
```

删除当前用户的 crontab 文件：

```bash
crontab -r
```

列出某个用户的 crontab 文件（需要有相应的权限）：

```bash
crontab -u username -l
```

编辑某个用户的 crontab 文件（需要有相应的权限）：

```bash
crontab -u username -e
```

```bash
*    *    *    *    *
-    -    -    -    -
|    |    |    |    |
|    |    |    |    +----- 星期中星期几 (0 - 6) (星期天 为0)
|    |    |    +---------- 月份 (1 - 12) 
|    |    +--------------- 一个月中的第几天 (1 - 31)
|    +-------------------- 小时 (0 - 23)
+------------------------- 分钟 (0 - 59)


50 7 * * * /sbin/service sshd start  意思是每天7：50开启ssh服务 
```

