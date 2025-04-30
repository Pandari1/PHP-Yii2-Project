FROM php:8.1-fpm

RUN apt-get update && apt-get install -y \
    git unzip curl libzip-dev libpng-dev libonig-dev zip \
    && docker-php-ext-install pdo_mysql zip gd

WORKDIR /var/www/html

# Copy everything from the 'src' folder into the container's working directory
COPY src/ .

RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

# Ensure that composer.json exists and install dependencies
RUN composer install --no-interaction --optimize-autoloader

EXPOSE 9000
CMD ["php-fpm"]
