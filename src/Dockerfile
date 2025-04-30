# src/Dockerfile

FROM php:8.1-fpm

# Set working directory
WORKDIR /var/www/html

# Install system dependencies and PHP extensions
RUN apt-get update && apt-get install -y \
    libzip-dev \
    zip \
    unzip \
    git \
    libonig-dev \
    libxml2-dev \
    libxslt-dev \
    && docker-php-ext-install pdo_mysql mbstring zip dom xsl

# Copy project files (assumes vendor/ is already generated in pipeline)
COPY . .

# Expose port
EXPOSE 9000

CMD ["php-fpm"]
