FROM php:7.4-fpm

# Install Nginx and dependencies
RUN apt-get update && apt-get install -y \
    nginx \
    curl \
    git \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Install PHP extensions for Yii2
RUN docker-php-ext-install pdo pdo_mysql

# Copy Yii2 application to container
COPY . /var/www/html
# Copy the Nginx main configuration file (this configures Nginx settings)
COPY nginx/default.conf /etc/nginx/sites-available/default

# Remove Apache2 since we are using Nginx
RUN apt-get purge -y apache2

# Set up the Nginx configuration file
COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80
EXPOSE 80

# Start Nginx and PHP-FPM
CMD service nginx start && php-fpm -D
