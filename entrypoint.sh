#!/bin/bash

# Exécuter les migrations si la variable d'environnement MIGRATE_ON_START est définie
if [ "$MIGRATE_ON_START" = "true" ]; then
  echo "Running migrations..."
  php /var/www/html/artisan migrate --force
fi

# Créer le lien symbolique pour le stockage
echo "Creating symlink for storage..."
php /var/www/html/artisan storage:link

# Démarrer le serveur PHP-FPM
exec php-fpm
