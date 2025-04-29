FROM php:7.4-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl git unzip libzip-dev zip \
    && docker-php-ext-install pdo pdo_mysql zip

# Copy application code
COPY ./src /var/www/html

# Set working directory
WORKDIR /var/www/html

# Set correct permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Expose PHP-FPM port
EXPOSE 9000
