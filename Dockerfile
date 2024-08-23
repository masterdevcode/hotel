# Étape de build
FROM composer:2 as build

WORKDIR /app

# Copier les fichiers de dépendances
COPY composer.json composer.lock ./

# Installer les dépendances
RUN composer install --no-dev --optimize-autoloader --no-scripts

# Copier le reste de l'application
COPY . .

# Générer les fichiers optimisés de Laravel
RUN php artisan config:cache && \
    php artisan route:cache && \
    php artisan view:cache && \
    php artisan event:cache

# Étape de production
FROM php:8.2-fpm

# Installer les dépendances nécessaires
RUN apt-get update && apt-get install -y \
    nginx \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Copier l'application depuis l'étape de build
COPY --from=build /app /var/www/html

# Copier la configuration Nginx
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf

# Définir les permissions correctes
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html/storage

# Exposer le port 80
EXPOSE 80 9000

# Démarrer Nginx et PHP-FPM
CMD ["sh", "-c", "php-fpm & nginx -g 'daemon off;'"]
