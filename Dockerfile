# Étape 1 : Utiliser une image de base Ubuntu avec PHP 8.0-FPM
FROM php:8.0-fpm AS base

# Installer les dépendances système et les extensions PHP nécessaires
RUN apt-get update && apt-get install -y \
    libpng-dev libjpeg-dev libfreetype6-dev \
    libzip-dev libicu-dev git unzip libxml2-dev nginx \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd zip intl xml pdo pdo_mysql \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Installer Composer
COPY --from=composer:2.6 /usr/bin/composer /usr/bin/composer

# Définir le répertoire de travail
WORKDIR /var/www/html

# Copier l'application Laravel dans le conteneur
COPY . .

# Ajuster les permissions des fichiers et dossiers
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 775 storage bootstrap/cache  \
    && chmod -R 755 /var/www/html

# Installer les dépendances PHP
RUN composer install --optimize-autoloader --no-dev

# Copier le fichier de configuration Nginx dans le conteneur
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf

# Exposer les ports nécessaires
EXPOSE 80 9000

# Démarrer PHP-FPM et Nginx
CMD ["sh", "-c", "php-fpm & nginx -g 'daemon off;'"]
