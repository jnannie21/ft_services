#!/bin/sh
mysql_install_db --user=mysql --datadir='/var/lib/mysql'
sed -i 's/skip-networking//g' /etc/my.cnf.d/mariadb-server.cnf

echo "CREATE DATABASE wordpress;" >> /tmp/sql_query
echo "CREATE USER 'root'@'%' IDENTIFIED BY '';" >> /tmp/sql_query
echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;" >> /tmp/sql_query
echo "FLUSH PRIVILEGES;" >> /tmp/sql

mysqld_safe --init_file=/tmp/sql_query
