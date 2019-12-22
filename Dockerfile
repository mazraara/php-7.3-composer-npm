FROM php:7.3.11-fpm
# https://github.com/docker-library/docs/blob/master/php/README.md#supported-tags-and-respective-dockerfile-links
RUN apt-get update && apt-get install -y libzip-dev libmcrypt-dev libpng-dev libfreetype6-dev libjpeg62-turbo-dev gnupg git zip unzip \
    default-mysql-client libmagickwand-dev --no-install-recommends \
    && pecl install imagick \
    && docker-php-ext-enable imagick \
    && docker-php-ext-install -j$(nproc) iconv \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install bcmath pdo_mysql opcache zip \
    && docker-php-ext-enable opcache
RUN yes '' | pecl install -f -o -f redis \
&&  rm -rf /tmp/pear \
&&  docker-php-ext-enable redis

RUN curl -sL https://deb.nodesource.com/setup_11.x | bash -
RUN apt-get install -y nodejs build-essential
RUN apt-get install -y ssh

RUN php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer

WORKDIR /var/www
