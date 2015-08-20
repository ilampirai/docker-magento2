FROM ubuntu:latest
MAINTAINER Ilampirai Nambi <mailme@ilam.in>

# Install packages
RUN apt-get update 
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install supervisor
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install git 
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install apache2 
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install libapache2-mod-php5
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install mysql-server-5.6 
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install php5-mysql 
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install pwgen 
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install php-apc
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install php5-curl
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install php5-gd
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install php5-mcrypt
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install php5-intl
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install php5-xsl
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install openssh-server
RUN php5enmod mcrypt

# Add image configuration and scripts
ADD start-apache2.sh /start-apache2.sh
ADD start-mysqld.sh /start-mysqld.sh
RUN service mysql start
ADD run.sh /run.sh
RUN chmod 755 /*.sh
#ADD my.cnf /etc/mysql/conf.d/my.cnf
ADD supervisord-apache2.conf /etc/supervisor/conf.d/supervisord-apache2.conf
ADD supervisord-mysqld.conf /etc/supervisor/conf.d/supervisord-mysqld.conf
ADD start-sshd.conf /etc/supervisor/conf.d/start-sshd.conf

# Remove pre-installed database
#RUN rm -rf /var/lib/mysql/*

# Add MySQL utils
ADD create_mysql_admin_user.sh /create_mysql_admin_user.sh
RUN chmod 755 /*.sh

# For openssh
RUN mkdir -p /var/run/sshd
RUN echo "root:admin123" | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i '$a\PermitRootLogin yes' /etc/ssh/ssh_config

# config to enable .htaccess
ADD apache_default /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite

#Enviornment variables to configure php
ENV PHP_UPLOAD_MAX_FILESIZE 10M
ENV PHP_POST_MAX_SIZE 10M

#Get Magento files
RUN rm -fr /var/www/html
RUN git clone https://github.com/magento/magento2.git /app/
RUN chmod -R o+w /app/pub /app/var
RUN chmod o+w /app/app/etc
RUN cd /app && /usr/bin/php -r "readfile('https://getcomposer.org/installer');" | /usr/bin/php
RUN cd /app && /usr/bin/php composer.phar install
RUN cd /app && wget http://sourceforge.net/projects/adminer/files/latest/download?source=files
RUN cd /app && mv download\?source\=files adminer.php

RUN mkdir -p /app && rm -fr /var/www/html && ln -s /app /var/www/html
# Add volumes for MySQL 
VOLUME  ["/etc/mysql", "/var/lib/mysql" ]

EXPOSE 80 3306 22
CMD ["/run.sh"]
