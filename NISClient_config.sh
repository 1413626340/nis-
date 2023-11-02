#!/bin/bash
read -p "请输入主hostname: " hostname
read -p "请输入从hostname: " chostname
yum install -y ypbind yp-tools
echo "NISDOMAIN=eda.com" >> /etc/sysconfig/network
nisdomainname eda.com
authconfig --enablenis --nisdomain=eda.com --nisserver=$hostname,$chostname --enablemkhomedir --update
systemctl start ypbind.service
systemctl enable ypbind.service
