#!/bin/bash
# Start PHP-FPM
service php8.0-fpm start

# Start Nginx
nginx -g "daemon off;"
