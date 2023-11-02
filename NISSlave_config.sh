#!/bin/bash
read -p "请输入允许访问的IP段格式为IP " ip
read -p "请输入子网掩码" netmask 
read -p "请输入同步的主服务器hostname(确保已完成IP-host映射)" hostname
yum install -y ypserv rpcbind yp-tools ypbind
echo "NISDOMAIN=eda.com" >> /etc/sysconfig/network
nisdomainname eda.com
echo "$ip/$netmask      : *     : *     : none" >> /etc/ypserv.conf
sed -ri "/^NOPUSH=/c NOPUSH=false" /var/yp/Makefile
echo "255.255.255.255 127.0.0.1" >> /var/yp/securenets
echo "$netmask $ip" >> /var/yp/securenets

systemctl start ypbind.service
systemctl start ypserv.service
systemctl start yppasswdd.service
systemctl start ypxfrd.service
systemctl enable  ypserv ypxfrd yppasswdd ypbind

/usr/lib64/yp/ypinit -s $hostname

#1.安装软件包
#2.添加NIS域名
#3.启动NIS域名
#4.设置Client对Server的访问权限
#5.设置主从同步选项
#6.添加从服务器到主服务器的配置文件中
