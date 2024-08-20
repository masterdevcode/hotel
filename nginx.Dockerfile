# Utiliser l'image Nginx
FROM nginx:1.19

# Copier les fichiers de l'application Laravel depuis l'image précédente
COPY --from=laravel-app /var/www/html /var/www/html

# Copier la configuration Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Exposer le port 80 pour Nginx
EXPOSE 80

# Définir le script d'entrée comme commande à exécuter
CMD ["nginx", "-g", "daemon off;"]