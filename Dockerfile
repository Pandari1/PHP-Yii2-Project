FROM php:7.4-fpm

# Install system dependencies and Nginx
RUN apt-get update && apt-get install -y \
    nginx curl git unzip libzip-dev zip \
    && docker-php-ext-install pdo pdo_mysql zip \
    && rm -rf /var/lib/apt/lists/*

# Copy app source
COPY ./src /var/www/html

# Copy nginx config
COPY nginx/default.conf /etc/nginx/conf.d/default.conf
COPY nginx/nginx.conf /etc/nginx/nginx.conf

WORKDIR /var/www/html

RUN chown -R www-data:www-data /var/www/html && chmod -R 755 /var/www/html

EXPOSE 80

CMD service php7.4-fpm start && nginx -g 'daemon off;'
