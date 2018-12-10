FROM php:7.0.32-apache-jessie
COPY server-name.conf /etc/apache2/conf-enabled/
RUN apt-get update -y \
    && apt-get install -y \ 
    libbz2-dev \ 
    libenchant-dev \ 
    libpng-dev \ 
    libgmp-dev \ 
    libc-client-dev \ 
    libkrb5-dev \ 
    firebird-dev \ 
    libicu-dev \ 
    libldb-dev \ 
    libldap2-dev \ 
    libmcrypt-dev \ 
    libreadline-dev \ 
    libxml2-dev \ 
    libxslt-dev \ 
    libpspell-dev \ 
    libmagickwand-dev --no-install-recommends \ 
    && rm -r /var/lib/apt/lists/*
RUN yes '' | pecl install imagick
RUN ln -s /usr/lib/x86_64-linux-gnu/libldap.so /usr/lib/libldap.so \
    && ln -s /usr/lib/x86_64-linux-gnu/liblber.so /usr/lib/liblber.so
RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl \ 
    && docker-php-ext-install pdo \ 
    pdo_mysql \
    ## apcu \ 
    ## apc \ 
    bcmath \ 
    bz2 \ 
    calendar \ 
    dba \ 
    enchant \ 
    gd \ 
    gettext \ 
    gmp \ 
    imap \ 
    interbase \ 
    intl \ 
    ldap \ 
    exif \ 
    mcrypt \ 
    mysqli \ 
    # odbc \ 
    # pdo_dblib \ 
    ## PDO_Firebird \ 
    ## PDO_ODBC \ 
    # pdo_pgsql \ 
    # pgsql \ 
    pspell \ 
    # recode \ 
    shmop \ 
    # snmp \ 
    # soap \ 
    sockets \ 
    sysvmsg \ 
    sysvsem \ 
    sysvshm \ 
    # tidy \ 
    # wddx \ 
    xmlrpc \ 
    xsl \ 
    zip \ 
    ## ionCube Loader \ 
    opcache \ 
    && a2enmod actions \ 
    auth_digest \ 
    authz_groupfile \ 
    cgi \ 
    dav \
    dav_fs \ 
    expires \ 
    headers \ 
    include \ 
    remoteip \  
    rewrite \ 
    socache_shmcb \ 
    speling \ 
    ssl \ 
    suexec \ 
    unique_id
RUN docker-php-ext-enable imagick
COPY php.ini /usr/local/etc/php/conf.d/
# prevent caching for development
COPY .htaccess /var/www/html/
COPY info.php /var/www/html/