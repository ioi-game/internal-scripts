#!/bin/bash

sudo su -

# eth1 installation
cat <<< 'DEVICE=eth1
BOOTPROTO=static
ONBOOT=yes
TYPE=Ethernet
USERCTL=yes
PEERDNS=yes
IPV6NOINIT=no
NETMASK=255.255.255.0
IPADDR=192.168.56.111
' > /etc/sysconfig/network-scripts/ifcfg-eth1

# allow login with password 
cat <<< '
PasswordAuthentication yes
' >> /etc/ssh/sshd_config

# samba and access to /var/www 
yum install -y samba samba-client samba-common
mkdir /var/www
chmod -R 0777 /var/www
chown ec2-user:ec2-user /var/www
cat <<< '[global]
workgroup = WORKGROUP
server string = Amazon Linux 2 server
security = user
passdb backend = tdbsam
map to guest = Bad Password

[www-data]
path = /var/www
guest ok = yes
writable = yes
printable = no
read only = no
browsable = yes
create mask = 0777
directory mask = 0777
public = yes
' > /etc/samba/smb.conf
