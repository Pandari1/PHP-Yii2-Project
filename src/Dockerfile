# Base image
FROM php:8.1-fpm

# Set working directory
WORKDIR /var/www/html

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    curl \
    libpng-dev \
    libzip-dev \
    libpq-dev \
    zip \
    && docker-php-ext-install zip pdo pdo_mysql gd

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy Composer files
COPY composer.json composer.lock ./

# Install PHP dependencies (including dev dependencies for build)
RUN composer install --no-interaction --prefer-dist --optimize-autoloader --no-scripts

# Copy application code
COPY . .

# Set proper permissions
RUN chown -R www-data:www-data /var/www/html \
    && find /var/www/html -type d -exec chmod 755 {} \; \
    && find /var/www/html -type f -exec chmod 644 {} \;

# Production optimizations (uncomment for production)
# RUN composer install --no-dev --optimize-autoloader

EXPOSE 9000

CMD ["php-fpm"]
