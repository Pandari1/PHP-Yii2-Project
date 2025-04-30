FROM php:8.1-fpm

# Install PHP extensions
RUN apt-get update && apt-get install -y \
    git unzip curl libzip-dev libpng-dev libonig-dev zip \
    && docker-php-ext-install pdo_mysql zip gd \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /var/www/html

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

# Copy only composer files first (for better Docker cache usage)
COPY src/composer.json ./ 

# Only copy composer.lock if it exists — handle gracefully
# This avoids failure if lock file is absent
COPY src/composer.lock ./ 

# Clear out any old cache and install fresh dependencies
RUN rm -rf /root/.composer/cache
RUN composer clear-cache
RUN composer install --no-interaction --prefer-dist --optimize-autoloader

# Copy entire application code
COPY src/ ./

# Expose port used by PHP-FPM
EXPOSE 9000

# Start PHP-FPM server
CMD ["php-fpm"]
