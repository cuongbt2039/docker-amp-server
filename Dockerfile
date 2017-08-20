FROM ubuntu:latest
MAINTAINER Ed Boraas <kratos@gow.com>

RUN \
	apt-get update && \
	apt-get install iputils-ping && \
	apt-get -y install apache2 php7.0 php7.0-mysql libapache2-mod-php7.0 curl lynx-cur && \ 
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

RUN a2enmod php7.0
RUN a2enmod rewrite

# Update the PHP.ini file, enable <? ?> tags and quieten logging.
RUN sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php/7.0/apache2/php.ini
RUN sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/php/7.0/apache2/php.ini

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

RUN /usr/sbin/a2ensite default-ssl
RUN /usr/sbin/a2enmod ssl

# Copy this repo into place.
ADD phukiendt /var/www/phukiendt

# Update the default apache site with the config we created.
ADD apache-config.conf /etc/apache2/sites-enabled/000-default.conf

EXPOSE 80
EXPOSE 443

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]