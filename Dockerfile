FROM php:7.4-fpm

# Install system dependencies and Nginx
RUN apt-get update && apt-get install -y \
    curl git unzip libzip-dev zip nginx \
    && docker-php-ext-install pdo pdo_mysql zip \
    && rm -rf /var/lib/apt/lists/*

# Copy application code
COPY ./src /var/www/html

# Copy Nginx configuration
COPY nginx/default.conf /etc/nginx/conf.d/default.conf
COPY nginx/nginx.conf /etc/nginx/nginx.conf

# Set working directory
WORKDIR /var/www/html

# Set permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Expose web port
EXPOSE 80

# Start Nginx and PHP-FPM together
CMD service php7.4-fpm start && nginx -g 'daemon off;'
