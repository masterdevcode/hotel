FROM php:8.1-fpm

# Install system dependencies
RUN apt-get update -yq \
    && apt-get install -yq \
    nginx \
    supervisor \
    mysql-client \
    nodejs \
    npm \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    libicu-dev \
    git \
    unzip \
    libxml2-dev

# Configure and install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd zip intl xml pdo pdo_mysql

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy application files
COPY . .

# Install application dependencies
RUN composer install --optimize-autoloader --no-dev
RUN npm install && npm run production

# Configure Nginx
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf

# Configure Supervisor
COPY ./docker-dev/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Set permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html/storage

# Expose ports
EXPOSE 80 443

# Start Supervisor
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
