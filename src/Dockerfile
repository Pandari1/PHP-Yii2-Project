FROM php:8.1-fpm
WORKDIR /var/www/html

RUN apt-get update && apt-get install -y \
    git unzip curl libzip-dev zip \
    && docker-php-ext-install zip pdo pdo_mysql

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Validate JSON before installation
COPY composer.* ./
RUN composer validate --no-check-all --no-check-publish && \
    composer install --no-interaction --prefer-dist --optimize-autoloader

COPY . .
RUN chown -R www-data:www-data /var/www/html && chmod -R 755 /var/www/html
EXPOSE 9000
CMD ["php-fpm"]
