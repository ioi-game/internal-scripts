#!/bin/bash

# run from local EC2: 
# curl -sL https://raw.githubusercontent.com/ioi-game/internal-scripts/main/install-php-7.4.sh | sudo bash -

sudo su -

# PHP
yum update -y
yum install -y amazon-linux-extras
amazon-linux-extras enable php7.4
yum install -y php php-{pear,cgi,common,curl,mbstring,gd,mysqlnd,gettext,bcmath,json,xml,fpm,intl,zip,imap,pdo,process,cli,devel,enchant,odbc,opcache,pecl-apcu,pecl-apcu-devel,pecl-igbinary,pecl-igbinary-devel,pecl-mailparse,pecl-memcache,pecl-memcached,pecl-msgpack,pecl-msgpack-devel,pecl-oauth,pecl-redis,pecl-ssh2,pecl-uuid,pgsql,pspell,snmp,soap,sodium,xmlrpc}
#problems:recode
#ignored:embedded,dba,dbg,gmp,ldap,mysql(replaced with mysqlnd),

# NGINX
amazon-linux-extras enable nginx1
yum clean metadata
yum install -y nginx

# todo - nginx config...

# CONFIGURE PHP FOR NGINX
#sed -i 's/cgi.fix_pathinfo = 0/#cgi.fix_pathinfo = 0/' /etc/php.ini
cat <<< '
cgi.fix_pathinfo = 0
' >> /etc/php.ini
sudo systemctl start php-fpm
sudo systemctl enable php-fpm
sudo systemctl status php-fpm


# see https://kirelos.com/how-to-install-php-8-0-on-centos-8-centos-7/
