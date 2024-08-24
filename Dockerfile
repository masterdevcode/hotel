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

# Use PHP 8.2-FPM as the base image
FROM php:8.2-fpm

# Copy composer.lock and composer.json
COPY composer.json /var/www/

# Set the working directory
WORKDIR /var/www

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl

# Clear the cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd intl

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Add a user for the Laravel application
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

# Copy existing application directory contents and set the proper permissions
COPY --chown=www:www . /var/www


# Définir les permissions correctes
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Change the current user to 'www'
USER www

# Copier la configuration Nginx
COPY ./nginx/nginx.conf /etc/nginx/conf.d/

# Expose port 9000 and start the PHP-FPM server
EXPOSE 9000
CMD ["php-fpm"]
