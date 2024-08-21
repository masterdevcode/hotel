# Base image: Ubuntu with PHP 8.0-FPM
FROM php:8.0-fpm AS base

# Install system dependencies and PHP extensions
RUN apt-get update && apt-get install -y \
    libpng-dev libjpeg-dev libfreetype6-dev \
    libzip-dev libicu-dev git unzip libxml2-dev \
    nginx \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd zip intl xml pdo pdo_mysql \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Composer
COPY --from=composer:2.6 /usr/bin/composer /usr/bin/composer

# Define working directory
WORKDIR /var/www/html

# Copy Laravel application into the container
COPY . .

# Set permissions
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Install PHP dependencies
RUN composer install --optimize-autoloader --no-dev

# Copy the Nginx configuration file
COPY ./nginx/nginx.conf /etc/nginx/conf.d/default.conf

# Expose necessary ports
EXPOSE 80 9000

# Start PHP-FPM and Nginx
CMD ["sh", "-c", "php-fpm & nginx -g 'daemon off;'"]
