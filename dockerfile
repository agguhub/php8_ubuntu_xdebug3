FROM php:8.2-apache

ENV COMPOSER_ALLOW_SUPERUSER=1

EXPOSE 80
WORKDIR /app

# git, unzip & zip are for composer
RUN apt-get update -qq && \
    apt-get install -qy \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# PHP Extensions
RUN docker-php-ext-install -j$(nproc) opcache pdo_mysql
COPY conf/php.ini /usr/local/etc/php/conf.d/app.ini

# Apache
COPY errors /errors
COPY conf/vhost.conf /etc/apache2/sites-available/000-default.conf
COPY conf/apache.conf /etc/apache2/conf-available/z-app.conf
COPY code_source/index.php /app/index.php
COPY conf/xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# xdebug
RUN pecl install xdebug-3.2.1 \
    && docker-php-ext-enable xdebug

RUN a2enmod rewrite remoteip && \
    a2enconf z-app