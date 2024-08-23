#!/bin/bash

CONFIG_FILE="/usr/local/etc/php-fpm.d/www.conf"

if [ -f "$CONFIG_FILE" ]; then
    if grep -q '^listen = 9000' "$CONFIG_FILE"; then
        echo "Configuration PHP-FPM déjà correcte."
    else
        echo "Ajout de 'listen = 9000' à la configuration PHP-FPM."
        echo 'listen = 9000' >> "$CONFIG_FILE"
    fi
    
    echo "Contenu actuel de la configuration PHP-FPM:"
    grep '^listen = ' "$CONFIG_FILE"
else
    echo "Erreur: Le fichier de configuration PHP-FPM n'existe pas à l'emplacement $CONFIG_FILE"
    exit 1
fi

# Vérifier si PHP-FPM est en cours d'exécution
if pgrep php-fpm > /dev/null; then
    echo "Redémarrage de PHP-FPM pour appliquer les changements."
    kill -USR2 $(pgrep php-fpm)
else
    echo "PHP-FPM n'est pas en cours d'exécution. Démarrage..."
    php-fpm
fi

echo "Configuration PHP-FPM terminée."