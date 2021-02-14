#!/bin/bash

# run from local EC2: 
# curl -sL https://raw.githubusercontent.com/ioi-game/internal-scripts/main/init-local-virtual-ec2.sh | sudo bash -

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
sed -i 's/PasswordAuthentication no/#PasswordAuthentication no/' /etc/ssh/sshd_config
cat <<< '
PasswordAuthentication yes
' >> /etc/ssh/sshd_config

# samba and access to /var/www 
yum install -y samba samba-client samba-common
mkdir /var/www
chmod -R 0777 /var/www
chown ec2-user:ec2-user /var/www
echo -ne "123\n123\n" | smbpasswd -a -s ec2-user
cat <<< '[global]
workgroup = WORKGROUP
server string = Amazon Linux 2 server

[www-data]
path = /var/www
writable = yes
browseable = yes
valid users = ec2-user
' > /etc/samba/smb.conf

systemctl enable smb.service
