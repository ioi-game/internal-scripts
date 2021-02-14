#!/bin/bash

# run from local EC2: 
# curl -sL https://raw.githubusercontent.com/ioi-game/internal-scripts/main/install-samba.sh | sudo bash -

sudo su -

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
