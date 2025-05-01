FROM php:8.1-fpm

# Set working directory inside container
WORKDIR /var/www/html

# Install system dependencies and PHP extensions
RUN apt-get update && apt-get install -y \
    zip \
    unzip \
    git \
    libzip-dev \
    libonig-dev \
    libxml2-dev \
    libxslt-dev \
    && docker-php-ext-install pdo_mysql mbstring zip dom xsl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install any additional dependencies or utilities if necessary
# RUN apt-get install -y some-package

# Copy application source code into the container
COPY . .

# Copy Composer from official Composer image
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Expose PHP-FPM port (optional, adjust based on actual use)
EXPOSE 9000

# Run php-fpm (PHP FastCGI Process Manager)
CMD ["php-fpm"]
