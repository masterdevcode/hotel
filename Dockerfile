# # Étape de build
# FROM composer:2 as build

# WORKDIR /app

# # Copier les fichiers de dépendances
# COPY composer.json ./

# # Installer les dépendances
# RUN composer install --no-dev --optimize-autoloader --no-scripts

# # Copier le reste de l'application
# COPY . .

# # Générer les fichiers optimisés de Laravel
# RUN php artisan config:cache && \
#     php artisan route:cache && \
#     php artisan view:cache && \
#     php artisan event:cache

# # Étape de production
# FROM php:8.2-fpm

# # Installer les dépendances nécessaires
# RUN apt-get update && apt-get install -y \
#     nginx \
#     libpng-dev \
#     libonig-dev \
#     libxml2-dev \
#     zip \
#     unzip \
#     && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd intl

# # Copier l'application depuis l'étape de build
# COPY --from=build /app /var/www/html

# # Copier la configuration Nginx
# COPY ./nginx/nginx.conf /etc/nginx/nginx.conf

# # Copier le script de configuration PHP-FPM
# COPY ./configure-php-fpm.sh /usr/local/bin/configure-php-fpm.sh
# RUN chmod +x /usr/local/bin/configure-php-fpm.sh && /usr/local/bin/configure-php-fpm.sh

# # Copier la configuration PHP-FPM personnalisée
# COPY ./nginx/php-fpm.conf /usr/local/etc/php-fpm.d/www.conf

# # S'assurer que le répertoire de logs PHP-FPM existe
# RUN mkdir -p /var/log/php-fpm && \
#     chown -R www-data:www-data /var/log/php-fpm && \
#     chmod -R 755 /var/log/php-fpm && \
#     touch /var/log/php-fpm/www-error.log && \
#     chown www-data:www-data /var/log/php-fpm/www-error.log

# # Définir les permissions correctes
# RUN chown -R www-data:www-data /var/www/html \
#     && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# # Exposer les ports nécessaires
# EXPOSE 80 9000

# # Démarrer Nginx et PHP-FPM
# CMD ["sh", "-c", "php-fpm -D && nginx -g 'daemon off;'"]

#========================================================================================

# Use the PHP 8.2 FPM image as the base image
FROM php:8.3-fpm

# Define build arguments
ARG user
ARG uid

ENV PHP_OPCACHE_ENABLE=1
USER root
# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    supervisor \
    nginx \
    build-essential \
    openssl \
    && docker-php-ext-install gd pdo pdo_mysql sockets exif mbstring bcmath intl pcntl imap

# Copy Composer binary from the Composer official Docker image
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Create system user to run Composer and Artisan commands
RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

WORKDIR /var/www

# Copy configuration files if necessary
COPY ./openssl.cnf /etc/ssl/openssl.cnf
COPY ./docker-dev/php.ini /usr/local/etc/php/php.ini

# Copy application files before running composer install
COPY . .

# Install Composer dependencies
RUN composer install --no-interaction --prefer-dist --optimize-autoloader

# Change ownership of application files
RUN chown -R $uid:$uid /var/www

# Copy Nginx configuration
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf

# Définir les permissions correctes
RUN chown -R www-data:www-data /var/www/ \
    && chmod -R 777 /var/www/storage /var/www/bootstrap/cache

# Copy Supervisor configuration
COPY ./supervisord.conf /etc/supervisord.conf

# Run Supervisor
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]

