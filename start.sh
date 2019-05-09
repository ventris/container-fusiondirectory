#!/bin/sh

cat << _EOF_ > /etc/fusiondirectory/fusiondirectory.conf
<?xml version="1.0"?>
<conf>
  <!-- Main section **********************************************************
       The main section defines global settings, which might be overridden by
       each location definition inside.

       For more information about the configuration parameters, take a look at
       the FusionDirectory.conf(5) manual page.
  -->
  <main default="ldap"
        logging="TRUE"
        displayErrors="FALSE"
        forceSSL="FALSE"
        templateCompileDirectory="/var/spool/fusiondirectory/"
        debugLevel="0"
    >

    <!-- Location definition -->
    <location name="ldap"
    >
        <referral URI="${FD_ADMIN_URI}" base="${FD_BASE}"
                        adminDn="${FD_ADMIN_DN}"
                        adminPassword="${FD_ADMIN_PASSWORD}" />
    </location>
  </main>
</conf>
_EOF_

exec fusiondirectory-setup --check-config

exec /usr/sbin/apache2 -D FOREGROUND
