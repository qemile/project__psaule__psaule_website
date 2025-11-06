# Étape 1 : Build avec PHP pour copier les fichiers (minimal)
FROM php:8.3-fpm-alpine AS builder

# Installe les extensions PHP nécessaires (basiques pour un site simple : gd pour images, etc.)
RUN apk add --no-cache libpng-dev libjpeg-turbo-dev freetype-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd

# Copie les fichiers du site
WORKDIR /var/www/html
COPY public/ ./

# Étape 2 : Image finale avec Nginx + PHP-FPM (multi-stage pour minimiser la taille)
FROM nginx:alpine

# Installe PHP-FPM dans l'image Nginx (léger)
RUN apk add --no-cache php83 php83-fpm php83-gd php83-openssl php83-pdo php83-mbstring php83-session \
    && mkdir -p /run/php /var/www/html \
    && chown -R nginx:nginx /var/www/html

# Copie les fichiers du builder
COPY --from=builder /var/www/html /var/www/html

# Config Nginx simple pour PHP (servir index.php, etc.)
RUN echo 'server {' > /etc/nginx/conf.d/default.conf && \
    echo '    listen 80;' >> /etc/nginx/conf.d/default.conf && \
    echo '    server_name _;' >> /etc/nginx/conf.d/default.conf && \
    echo '    root /var/www/html;' >> /etc/nginx/conf.d/default.conf && \
    echo '    index index.php index.html;' >> /etc/nginx/conf.d/default.conf && \
    echo '' >> /etc/nginx/conf.d/default.conf && \
    echo '    location / {' >> /etc/nginx/conf.d/default.conf && \
    echo '        try_files $uri $uri/ /index.php?$args;' >> /etc/nginx/conf.d/default.conf && \
    echo '    }' >> /etc/nginx/conf.d/default.conf && \
    echo '' >> /etc/nginx/conf.d/default.conf && \
    echo '    location ~ \.php$ {' >> /etc/nginx/conf.d/default.conf && \
    echo '        include fastcgi_params;' >> /etc/nginx/conf.d/default.conf && \
    echo '        fastcgi_pass unix:/run/php/php-fpm.sock;' >> /etc/nginx/conf.d/default.conf && \
    echo '        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;' >> /etc/nginx/conf.d/default.conf && \
    echo '    }' >> /etc/nginx/conf.d/default.conf && \
    echo '}' >> /etc/nginx/conf.d/default.conf

# Config PHP-FPM minimal (idle bas)
RUN echo '[www]' > /etc/php83/php-fpm.d/www.conf && \
    echo 'user = nginx' >> /etc/php83/php-fpm.d/www.conf && \
    echo 'group = nginx' >> /etc/php83/php-fpm.d/www.conf && \
    echo 'listen = /run/php/php-fpm.sock' >> /etc/php83/php-fpm.d/www.conf && \
    echo 'listen.owner = nginx' >> /etc/php83/php-fpm.d/www.conf && \
    echo 'listen.group = nginx' >> /etc/php83/php-fpm.d/www.conf && \
    echo 'pm = ondemand' >> /etc/php83/php-fpm.d/www.conf && \
    echo 'pm.max_children = 5' >> /etc/php83/php-fpm.d/www.conf && \
    echo 'pm.process_idle_timeout = 10s' >> /etc/php83/php-fpm.d/www.conf

# Expose port 80
EXPOSE 80

# Start PHP-FPM et Nginx
CMD ["sh", "-c", "php-fpm83 -D && nginx -g 'daemon off;'"]


