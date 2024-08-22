# Étape 1 : Utiliser l'image PHP-FPM 8.0
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
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
# Définir le répertoire de travail
WORKDIR /var/www/html


# Copier l'application Laravel dans le conteneur
COPY . .

# Ajuster les permissions des fichiers et dossiers
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 775 storage bootstrap/cache

# Installer les dépendances PHP
RUN composer install --no-interaction --prefer-dist --optimize-autoloader

# Copier le fichier de configuration Nginx dans le conteneur
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf

# Exposer les ports nécessaires
EXPOSE 80 9000

# Démarrer PHP-FPM et Nginx
CMD ["sh", "-c", "php-fpm & nginx -g 'daemon off;'"]
