# Base image: Ubuntu with PHP 8.0-FPM
FROM ubuntu:22.04 as base

# Step 1: Install necessary dependencies
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
    php8.0-fpm php8.0-mysql php8.0-xml php8.0-mbstring php8.0-zip php8.0-intl \
    php8.0-gd php8.0-curl php8.0-bcmath php8.0-json \
    libpng-dev libjpeg-dev libfreetype6-dev libzip-dev libicu-dev git unzip curl \
    nginx supervisor \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Step 2: Install Composer
COPY --from=composer:2.6 /usr/bin/composer /usr/bin/composer

# Step 3: Define the working directory
WORKDIR /var/www/html

# Step 4: Copy Laravel application into the container
COPY . .

# Step 5: Set the correct permissions
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 775 storage bootstrap/cache

# Step 6: Install PHP dependencies
RUN composer install --optimize-autoloader --no-dev

# Step 7: Copy the Nginx configuration file
COPY nginx/nginx.conf /etc/nginx/sites-available/default

# Step 8: Copy the entrypoint script and give it execution permissions
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Step 9: Expose necessary ports
EXPOSE 80

# Step 10: Define the default command
CMD ["/usr/local/bin/entrypoint.sh"]
