FROM debian:testing

RUN DEBIAN_FRONTEND=noninteractive apt-get update; \
		apt-get install -y gnupg2 patch ca-certificates;

RUN apt-key adv --keyserver hkp://pgp.surfnet.nl:80 --recv-keys 0xD744D55EACDA69FF && \
		echo "deb http://repos.fusiondirectory.org/fusiondirectory-releases/fusiondirectory-1.2/debian-jessie jessie main" > /etc/apt/sources.list.d/fusiondirectory-jessie.list && \
		echo "deb http://repos.fusiondirectory.org/fusiondirectory-extra/debian-jessie jessie main" >> /etc/apt/sources.list.d/fusiondirectory-jessie.list && \
		apt-get update

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y apache2 dumb-init \
		fusiondirectory fusiondirectory-plugin-mail fusiondirectory-plugin-mixedgroups \
		fusiondirectory-plugin-ssh fusiondirectory-plugin-personal \
		fusiondirectory-plugin-posix fusiondirectory-smarty3-acl-render \
		fusiondirectory-plugin-webservice php-mdb2 php-mbstring php-fpm php libapache2-mod-php

ADD /apache/fusiondirectory.conf /etc/apache2/sites-available
ADD /apache/ports.conf /etc/apache2/ports.conf
ADD /ldap/ldap.conf /etc/ldap/ldap.conf
ADD /start.sh /

ADD /fd/*.patch /tmp/
RUN ls /tmp/*.patch | xargs -n1 patch -p1 -d /usr/share/fusiondirectory/ -i; rm -f /tmp/*.patch

RUN a2ensite fusiondirectory.conf; \
	a2dissite 000-default.conf

ENV APACHE_RUN_DIR /etc/apache2
ENV APACHE_PID_FILE /etc/apache2/apache2.pid
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

ENTRYPOINT ["/usr/bin/dumb-init", "--"]

EXPOSE 8000

CMD ["/start.sh"]
