FROM debian:testing

RUN DEBIAN_FRONTEND=noninteractive apt-get update; \
		apt-get install -y gnupg2;

RUN apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 0xD744D55EACDA69FF && \
		echo "deb http://repos.fusiondirectory.org/fusiondirectory-releases/fusiondirectory-1.2/debian-jessie jessie main" > /etc/apt/sources.list.d/fusiondirectory-jessie.list && \
		echo "deb http://repos.fusiondirectory.org/fusiondirectory-extra/debian-jessie jessie main" >> /etc/apt/sources.list.d/fusiondirectory-jessie.list && \
		apt-get update

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y apache2 dumb-init fusiondirectory fusiondirectory-plugin-mail fusiondirectory-plugin-ssh fusiondirectory-smarty3-acl-render php-mdb2 php-mbstring php-fpm php

ADD /apache/fusiondirectory.conf /etc/apache2/sites-available
ADD /apache/ports.conf /etc/apache2/ports.conf
ADD /fd/class_groupManagement.inc /usr/share/fusiondirectory/plugins/admin/groups/class_groupManagement.inc
ADD /ldap/ldap.conf /etc/ldap/ldap.conf

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
