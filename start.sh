#!/bin/sh

cat << _EOF_ > /etc/fusiondirectory/fusiondirectory.conf
<?xml version="1.0"?>
<conf>
  <main default="ldap"
        logging="TRUE"
        displayErrors="FALSE"
        forceSSL="FALSE"
        templateCompileDirectory="/var/spool/fusiondirectory/"
        debugLevel="0"
    >

    <location name="ldap"
    >
        <referral URI="${FD_ADMIN_URI}"
                        adminDn="${FD_ADMIN_DN}"
                        adminPassword="${FD_ADMIN_PASSWORD}" />
    </location>
  </main>
</conf>
_EOF_

exec /usr/sbin/apache2 -D FOREGROUND
