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

FROM php:8.2-fpm

ARG user
ARG uid

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
    openssl

RUN docker-php-ext-install gd pdo pdo_mysql sockets

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Create system user to run Composer and Artisan Commands
RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

WORKDIR /var/www

# If you need to fix ssl
COPY ./openssl.cnf /etc/ssl/openssl.cnf
# If you need add extension
COPY ./php.ini /usr/local/etc/php/php.ini

COPY composer.json ./
RUN composer install --no-dev --optimize-autoloader --no-scripts

COPY . .

RUN chown -R $uid:$uid /var/www

# copy supervisor configuration
COPY ./supervisord.conf /etc/supervisord.conf

# run supervisor
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]