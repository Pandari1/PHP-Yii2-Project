# Set base image
FROM php:8.1-fpm

# Install PHP extensions
RUN apt-get update && apt-get install -y \
    git unzip curl libzip-dev libpng-dev libonig-dev zip \
    && docker-php-ext-install pdo_mysql zip gd

WORKDIR /var/www/html

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

RUN composer clear-cache

# Copy only necessary files for faster build caching
COPY ./src/composer.json ./
COPY ./src/composer.lock ./

# Install dependencies
RUN composer install -vvv --no-interaction --prefer-dist --optimize-autoloader


# Copy rest of the app
COPY . /var/www/html/

EXPOSE 9000
CMD ["php-fpm"]
