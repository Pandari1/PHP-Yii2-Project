FROM php:7.4-fpm

# Install PHP extensions and system dependencies
RUN apt-get update && apt-get install -y \
    curl git unzip libzip-dev zip \
    && docker-php-ext-install pdo pdo_mysql zip \
    && rm -rf /var/lib/apt/lists/*

# Install NGINX
RUN apt-get update && apt-get install -y nginx

# Copy NGINX configuration files
COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/default.conf /etc/nginx/conf.d/default.conf

# Copy Yii2 application source
COPY ./src /var/www/html

# Set working directory
WORKDIR /var/www/html

# Set proper permissions
RUN chown -R www-data:www-data /var/www/html && chmod -R 755 /var/www/html

# Expose PHP-FPM and NGINX ports
EXPOSE 9000 80

# Start PHP-FPM and NGINX server
CMD service nginx start && php-fpm
