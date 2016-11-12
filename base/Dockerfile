FROM nginx:latest

# Copy preconfigured locations
ADD location /etc/nginx/location

# Copy configuration file
ADD conf.d/php-fpm.conf /etc/nginx/conf.d/default.conf
ADD conf.d/health-check.conf /etc/nginx/conf.d/health-check.conf
ADD conf.d/cache.conf /etc/nginx/conf.d/cache.conf
ADD conf.d/cors.conf /etc/nginx/conf.d/cors.conf

# tweak nginx config
ADD nginx.conf /etc/nginx/nginx.conf

EXPOSE 80 81 8080
