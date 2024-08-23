# Utiliser l'image officielle PHP-FPM
FROM php:8.1-fpm

# Installer les dépendances et extensions PHP nécessaires
RUN apt-get update && apt-get install -y \
    nginx \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Installer Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Définir le répertoire de travail
WORKDIR /var/www/html

# Copier les fichiers de l'application
COPY . /var/www/html

# Installer les dépendances de l'application
RUN composer install --no-dev --optimize-autoloader

# Générer les fichiers optimisés de Laravel
RUN php artisan config:cache && \
    php artisan route:cache && \
    php artisan view:cache && \
    php artisan event:cache

# Copier la configuration Nginx
COPY ./nginx/nginx.conf /etc/nginx/sites-available/default

# Définir les permissions correctes
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html/storage

# Exposer le port 80
EXPOSE 80

# Démarrer Nginx et PHP-FPM
CMD service nginx start && php-fpm