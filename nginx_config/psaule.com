# From site.conf of base_config

server {
    listen 80;
    listen [::]:80;

    # The www host server name.
    server_name www.psaule.com;

    # Redirect to the non-www version.
    return 301 $scheme://psaule.com$request_uri;
}

server {
    listen 80;
    listen [::]:80;

    # The non-www host server name.
    server_name psaule.com;

    # The document root path.
    root /var/www/psaule.com/public;

    # The charset.
    charset utf-8;

    # Files that will be used as index.
    index index.php;

    location ~ \.php$ {
        include snippets/directive/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.1-fpm.sock;
    }

    location / {
        # First attempt to serve request as a file, then as a directory, then
        # fallback to display 404 Not Found.
        try_files $uri $uri/ =404;
    }

    # Custom 404 page.
    error_page 404 /404.html;

    # Log configuration.
    error_log /etc/nginx/logs/psaule.com_error.log error;
    access_log /etc/nginx/logs/psaule.com_access.log main;

    # Include basic configuration.
    include snippets/basic.conf;
}
