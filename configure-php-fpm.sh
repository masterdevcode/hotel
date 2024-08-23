#!/bin/bash

# Vérifie si le fichier www.conf existe
if [ -f /usr/local/etc/php-fpm.d/www.conf ]; then
  # Ajoute la ligne listen = 9000 si elle n'existe pas
  grep -q '^listen = 9000' /usr/local/etc/php-fpm.d/www.conf || echo 'listen = 9000' >> /usr/local/etc/php-fpm.d/www.conf
else
  echo "Le fichier de configuration PHP-FPM n'existe pas à l'emplacement attendu."
fi
