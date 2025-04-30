FROM php:8.1-fpm

WORKDIR /var/www/html

# Copy application code
COPY src/ .              # adjust path if needed

# Copy existing vendor dir (already installed via Jenkins/local)
COPY vendor/ ./vendor/

# No composer install in Docker
# RUN composer validate ...
# RUN composer install ...

EXPOSE 9000
