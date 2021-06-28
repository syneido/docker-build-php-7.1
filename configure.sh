#!/usr/bin/env sh

set -ex

PHP_EXTENSIONS="opcache bcmath bz2 calendar exif gd gettext gmp intl mcrypt recode shmop soap sockets sysvmsg sysvsem sysvshm tidy xsl mysqli pdo_mysql wddx zip pcntl"
PECL_EXTENSION_PACKAGES="apcu-5.1.20 imagick-3.4.4 sqlsrv-5.6.1 pdo_sqlsrv-5.6.1"
PECL_EXTENSIONS="apcu imagick sqlsrv pdo_sqlsrv"
RUN_DEPS="unzip libzip icu libxslt imagemagick libmcrypt recode tidyhtml freetype libjpeg-turbo libpng libwebp libxpm"
BUILD_DEPS="autoconf g++ make libzip-dev zlib-dev libpng-dev libxml2-dev icu-dev bzip2-dev libc-dev gmp-dev libmcrypt-dev recode-dev gettext-dev tidyhtml-dev libxslt-dev imagemagick-dev freetype-dev libjpeg-turbo-dev libpng-dev libwebp-dev libxpm-dev tzdata unixodbc-dev"

apk add --no-cache --virtual rundeps ${RUN_DEPS}
apk add --no-cache --virtual .build-deps ${BUILD_DEPS}

### Fix pecl for official php7.1 image
pecl channel-update pecl.php.net

docker-php-source extract
docker-php-ext-configure gd --with-gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/ --with-xpm-dir=/usr/include/ --with-webp-dir=/usr/include/
docker-php-ext-install -j"$(nproc)" ${PHP_EXTENSIONS}
pecl install ${PECL_EXTENSION_PACKAGES}
docker-php-ext-enable ${PECL_EXTENSIONS}

docker-php-source delete
rm -r /tmp/pear/cache/* /tmp/pear/download/*

### TimeZone
cp /usr/share/zoneinfo/Europe/Paris /etc/localtime
echo "Europe/Paris" >  /etc/timezone

### Custom - Sql Server
curl -O https://download.microsoft.com/download/e/4/e/e4e67866-dffd-428c-aac7-8d28ddafb39b/msodbcsql17_17.7.2.1-1_amd64.apk
apk add --allow-untrusted msodbcsql17_17.7.2.1-1_amd64.apk
rm msodbcsql17_17.7.2.1-1_amd64.apk

apk del .build-deps
