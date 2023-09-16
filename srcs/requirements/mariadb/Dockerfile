FROM alpine:3.16

# ARG DB_NAME \
#     DB_USER \
#     DB_PASS \
#     DB_ROOT

# RUN apk update && apk add --no-cache mariadb mariadb-client

# RUN mkdir /var/run/mysqld; \
#     chmod 777 /var/run/mysqld; \
#     { echo '[mysqld]'; \
#       echo 'skip-host-cache'; \
#       echo 'skip-name-resolve'; \
#       echo 'bind-address=0.0.0.0'; \
#     } | tee /etc/my.cnf.d/docker.cnf; \
#     sed -i "s|skip-networking|skip-networking=0|g" \
#       /etc/my.cnf.d/mariadb-server.cnf

# RUN mysql_install_db --user=mysql --datadir=/var/lib/mysql

# EXPOSE 3306

# COPY requirements/mariadb/conf/create_db.sh .

# RUN sh create_db.sh && rm create_db.sh

# USER mysql

# CMD ["/usr/bin/mysqld", "--skip-log-error"]


RUN apt-get update && apt-get -y install mariadb-server mariadb-client \
&& rm -rf /var/lib/apt/lists/* \
# purge and re-create /var/lib/mysql with appropriate ownership
&& mkdir -p /var/run/mysqld \
&& chown -R mysql:mysql /var/run/mysqld \
# ensure that /var/run/mysqld (used for socket and lock files) is writable regardless of the UID our mysqld instance ends up having at runtime
&& chmod 777 /var/run/mysqld

EXPOSE 3306

COPY ./tools/create_db.sh /usr/local/bin/
COPY ./conf/wordpress.sql /usr/local/bin/
ENTRYPOINT ["create_db.sh"]

#Command to launch mariadb and enable the database to listen globally

CMD ["mysqld", "--bind-address=0.0.0.0"]