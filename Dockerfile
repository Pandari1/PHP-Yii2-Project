# Use the official PHP 7.4 FPM image as the base
FROM php:7.4-fpm

# Install Nginx, PHP extensions, and other necessary dependencies
RUN apt-get update && apt-get install -y \
    nginx \
    curl \
    git \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Install PHP extensions required for Yii2
RUN docker-php-ext-install pdo pdo_mysql

# Copy the Yii2 application files to the container
COPY . /var/www/html

# Copy the Nginx site configuration file to the container
COPY nginx/default.conf /etc/nginx/sites-available/default

# Copy the Nginx main configuration file (this configures Nginx settings)
COPY nginx/nginx.conf /etc/nginx/nginx.conf

# Expose port 80 to access the application
EXPOSE 80

# Ensure Nginx and PHP-FPM run together in the container
CMD service nginx start && php-fpm -D
