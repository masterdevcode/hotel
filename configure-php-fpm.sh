#!/bin/bash

CONFIG_FILE="/usr/local/etc/php-fpm.d/www.conf"

if [ -f "$CONFIG_FILE" ]; then
    if ! grep -q '^listen = 9000' "$CONFIG_FILE"; then
        echo "Ajout de 'listen = 9000' à la configuration PHP-FPM."
        echo 'listen = 9000' >> "$CONFIG_FILE"
        echo "Configuration mise à jour avec succès."
    else
        echo "La configuration 'listen = 9000' existe déjà dans le fichier."
    fi
else
    echo "Erreur: Le fichier de configuration PHP-FPM n'existe pas à l'emplacement $CONFIG_FILE"
    exit 1
fi

echo "Configuration PHP-FPM terminée."