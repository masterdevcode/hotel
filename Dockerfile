# Base image: Ubuntu
FROM ubuntu:22.04 as base

# Step 1: Install necessary dependencies
RUN apt-get update && apt-get install -y \
    software-properties-common \
    curl \
    gnupg \
    ca-certificates \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    libicu-dev \
    git \
    unzip \
    nginx \
    supervisor \
    && rm -rf /var/lib/apt/lists/*

# Step 2: Add PHP repository and install PHP
RUN add-apt-repository ppa:ondrej/php && \
    apt-get update && \
    apt-get install -y \
    php8.0-fpm \
    php8.0-gd \
    php8.0-zip \
    php8.0-intl \
    php8.0-pdo \
    php8.0-mysql \
    php8.0-bcmath \
    && rm -rf /var/lib/apt/lists/*

# Step 3: Install Composer
COPY --from=composer:2.6 /usr/bin/composer /usr/bin/composer

# Step 4: Define the working directory
WORKDIR /var/www/html

# Step 5: Copy Laravel application into the container
COPY . .

# Step 6: Set the correct permissions
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 775 storage bootstrap/cache

# Step 7: Install PHP dependencies
RUN composer install --optimize-autoloader --no-dev

# Step 8: Copy the Nginx configuration file
COPY nginx/nginx.conf /etc/nginx/sites-available/default

# Step 9: Copy the entrypoint script and give it execution permissions
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Step 10: Expose necessary ports
EXPOSE 80

# Step 11: Define the default command
CMD ["/usr/local/bin/entrypoint.sh"]
