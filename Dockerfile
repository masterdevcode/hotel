# Use PHP-FPM 8.0
FROM php:8.0-fpm

# Install system dependencies and PHP extensions
RUN apt-get update && apt-get install -y \
    libpng-dev libjpeg-dev libfreetype6-dev \
    libzip-dev libicu-dev git unzip libxml2-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd zip intl xml pdo pdo_mysql

# Set the working directory
WORKDIR /app

# Copy the Laravel application to the container
COPY . /app

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install PHP dependencies
RUN composer install --optimize-autoloader --no-dev

# Expose port 9000 for PHP-FPM
EXPOSE 9000

CMD ["php-fpm"]
