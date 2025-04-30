FROM php:8.1-fpm

RUN apt-get update && apt-get install -y \
    git unzip curl libzip-dev libpng-dev libonig-dev zip \
    && docker-php-ext-install pdo_mysql zip gd

WORKDIR /var/www/html

# Copy composer.json first to ensure layer caching works
COPY src/composer.json /var/www/html/composer.json

RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

# Install dependencies
RUN composer install --no-interaction --optimize-autoloader

# Copy the rest of the project files
COPY src/ /var/www/html/

EXPOSE 9000
CMD ["php-fpm"]
