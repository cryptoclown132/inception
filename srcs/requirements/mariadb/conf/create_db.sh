#!/bin/sh

mysql_install_db

/etc/init.d/mysql start

#Check if the database exists

if [ -d "/var/lib/mysql/$DB_NAME" ]
then 

	echo "Database already exists"
else

# Set root option so that connexion without root password is not possible

mysql_secure_installation <<_EOF_

Y
root4life
root4life
Y
n
Y
Y
_EOF_

#Add a root user on 127.0.0.1 to allow remote connexion

	echo "GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY '$DB_ROOT'; FLUSH PRIVILEGES;" | mysql -uroot

#Create database and user for wordpress
	echo "CREATE DATABASE IF NOT EXISTS $DB_NAME; GRANT ALL ON $DB_NAME.* TO '$DB_USER'@'%' IDENTIFIED BY '$DB_PASS'; FLUSH PRIVILEGES;" | mysql -uroot

#Import database
mysql -uroot -p$DB_ROOT $DB_NAME < /usr/local/bin/wordpress.sql

fi

/etc/init.d/mysql stop

exec "$@"
# #!bin/sh

# if [ ! -d "/var/lib/mysql/mysql" ]; then

#         chown -R mysql:mysql /var/lib/mysql

#         # init database
#         mysql_install_db --basedir=/usr --datadir=/var/lib/mysql --user=mysql --rpm

#         tfile=`mktemp`
#         if [ ! -f "$tfile" ]; then
#                 return 1
#         fi
# fi

# if [ ! -d "/var/lib/mysql/wordpress" ]; then

#         cat << EOF > /tmp/create_db.sql
# USE mysql;
# FLUSH PRIVILEGES;
# DELETE FROM     mysql.user WHERE User='';
# DROP DATABASE test;
# DELETE FROM mysql.db WHERE Db='test';
# DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
# ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT}';
# CREATE DATABASE ${DB_NAME} CHARACTER SET utf8 COLLATE utf8_general_ci;
# CREATE USER '${DB_USER}'@'%' IDENTIFIED by '${DB_PASS}';
# GRANT ALL PRIVILEGES ON wordpress.* TO '${DB_USER}'@'%';
# FLUSH PRIVILEGES;
# EOF
#         # run init.sql
#         /usr/bin/mysqld --user=mysql --bootstrap < /tmp/create_db.sql
#         rm -f /tmp/create_db.sql
# fi