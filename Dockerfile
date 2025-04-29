FROM php:7.4-fpm

# Install system dependencies and NGINX
RUN apt-get update && apt-get install -y \
    nginx curl git unzip libzip-dev zip \
    && docker-php-ext-install pdo pdo_mysql zip \
    && rm -rf /var/lib/apt/lists/*

# Copy application source code
COPY ./src /var/www/html

# Copy NGINX configuration
COPY nginx/default.conf /etc/nginx/conf.d/default.conf
COPY nginx/nginx.conf /etc/nginx/nginx.conf

# Set working directory
WORKDIR /var/www/html

# Set file permissions
RUN chown -R www-data:www-data /var/www/html && chmod -R 755 /var/www/html

# Expose HTTP port
EXPOSE 80

# Start PHP-FPM in background and NGINX in foreground
CMD ["sh", "-c", "php-fpm -D && nginx -g 'daemon off;'"]
