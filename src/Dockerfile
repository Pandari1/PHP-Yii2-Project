# src/Dockerfile
FROM php:8.1-fpm

# Set working directory
WORKDIR /var/www/html

# Install system dependencies and PHP extensions
RUN apt-get update && apt-get install -y \
    zip unzip git libzip-dev libonig-dev libxml2-dev libxslt-dev \
    && docker-php-ext-install pdo_mysql mbstring zip dom xsl

# Copy project files
COPY . .

# Copy Composer from official Composer image
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Expose PHP-FPM port
EXPOSE 9000

CMD ["php-fpm"]
