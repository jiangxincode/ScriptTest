## move.sh

将当前目录下大于10K的文件转移到/tmp目录下

## print_ip_network1.sh

获取本机的网络地址（方法一）
比如：本机的ip地址是：192.168.100.2/255.255.255.0，那么它的网络地址是
192.168.100.2/255.255.255.0
此方法仅适用于redhat系列linux系统

## print_ip_network2.sh

获取本机的网络地址（方法二）
比如：本机的ip地址是：192.168.100.2/255.255.255.0，那么它的网络地址是
192.168.100.2/255.255.255.0
此方法仅适用于大部分linux系统

## httpd.sh

Start/stop/restart the Apache web server.

## make_dir.sh

在/userdata目录下建立50个目录，即user1～user50，并设置每个目录的权限:
其他用户的权限为：读；
文件所有者的权限为：读、写、执行；
文件所有者所在组的权限为：读、执行。

## rename.sh

Rename a group of files from a filetype to another.
(for example:*.c->*.cpp)
思路如下：

- 查找出相应扩展名的文件
- 去除扩展名
- 使用awk将要进行的操作以字符串命令形式组合
- 将组合完毕的字符串传递给shell执行

## killcpu

A script for kill cup resource. If you want to construct an alarm, you may need it.
