FROM php:8.1-fpm

# Install PHP extensions
RUN apt-get update && apt-get install -y \
    git unzip curl libzip-dev libpng-dev libonig-dev zip \
    && docker-php-ext-install pdo_mysql zip gd

# Set working directory
WORKDIR /var/www/html

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

# Copy composer files first for caching
COPY src/composer.json /var/www/html/
COPY src/composer.lock /var/www/html/  # Optional, if present

# Install dependencies
RUN composer install --no-interaction --optimize-autoloader

# Copy the rest of the application
COPY src/ /var/www/html/

EXPOSE 9000
CMD ["php-fpm"]
