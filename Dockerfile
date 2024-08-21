# Étape 1 : Utiliser l'image PHP-FPM 8.0 pour construire l'application Laravel
FROM php:8.0-fpm AS laravel-app

# Installer les dépendances système et les extensions PHP
RUN apt-get update && apt-get install -y \
    libpng-dev libjpeg-dev libfreetype6-dev \
    libzip-dev libicu-dev git unzip libxml2-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd zip intl xml pdo pdo_mysql

# Installer Composer
COPY --from=composer:2.6 /usr/bin/composer /usr/bin/composer

# Définir le répertoire de travail
WORKDIR /var/www/html

# Copier l'application Laravel dans le conteneur
COPY . .

# Donner les permissions d'écriture nécessaires
RUN chmod -R 775 storage bootstrap/cache

# Installer les dépendances PHP
RUN composer install --optimize-autoloader --no-dev

# Copier le script d'entrée
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# Donner les permissions d'exécution au script d'entrée
RUN chmod +x /usr/local/bin/entrypoint.sh

# Exposer le port 9000 pour PHP-FPM
EXPOSE 9000

# Démarrer PHP-FPM
CMD ["php-fpm"]

# Étape 2 : Utiliser l'image Nginx pour servir l'application Laravel
FROM nginx:1.19 AS nginx

# Copier les fichiers de l'application Laravel depuis l'étape précédente
COPY --from=laravel-app /var/www/html /var/www/html

# Copier la configuration Nginx
COPY ./nginx/nginx.conf /etc/nginx/conf.d/default.conf

# Exposer le port 80 pour Nginx
EXPOSE 80

# Démarrer Nginx
CMD ["nginx", "-g", "daemon off;"]
