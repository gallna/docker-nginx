FROM nginx:latest

# Copy preconfigured locations
ADD location /etc/nginx/location

# Copy configuration file
ADD conf.d/php-fpm.conf /etc/nginx/conf.d/default.conf
