FROM php:8.1-fpm

WORKDIR /var/www/html

# Copy application code and pre-installed vendor dir
COPY src/ .               # your Yii2 source code
COPY vendor/ ./vendor/    # already installed by Jenkins

# Add PHP extensions as needed (example below)
RUN docker-php-ext-install pdo pdo_mysql

EXPOSE 9000
