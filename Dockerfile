# Utiliser l'image PHP-FPM 8.0 comme base
FROM php:8.0-fpm

# Installer les dépendances système et les extensions PHP
RUN apt-get update && apt-get install -y \
    libpng-dev libjpeg-dev libfreetype6-dev \
    libzip-dev libicu-dev git unzip libxml2-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd zip intl xml pdo pdo_mysql

# Définir le répertoire de travail
WORKDIR /var/www/html

# Copier l'application Laravel dans le conteneur
COPY . /var/www/html

# Installer Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Installer les dépendances PHP
RUN composer install --optimize-autoloader --no-dev

# Exposer le port 9000 pour PHP-FPM
EXPOSE 9000

# Copier le script d'entrée
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# Donner les permissions d'exécution au script d'entrée
RUN chmod +x /usr/local/bin/entrypoint.sh

# Définir le script d'entrée comme commande à exécuter
ENTRYPOINT ["entrypoint.sh"]
