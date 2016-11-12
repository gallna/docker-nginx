FROM gallna/nginx:latest

# Copy configuration
ADD ./conf.d/cache.conf /etc/nginx/conf.d/cache.conf

VOLUME /cache
EXPOSE 80 81 443 8080
