FROM php:7.4-apache

RUN apt-get update && apt-get install -y \
    git unzip zip libzip-dev libpng-dev libjpeg-dev libfreetype6-dev \
    && docker-php-ext-install zip pdo pdo_mysql gd

COPY ./src /var/www/html
WORKDIR /var/www/html

RUN mkdir -p runtime web/assets \
 && chown -R www-data:www-data /var/www/html \
 && chmod -R 755 /var/www/html

EXPOSE 80