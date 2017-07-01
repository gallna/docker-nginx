FROM gallna/nginx:latest

# Copy configuration
ADD ./conf.d/cache.conf /etc/nginx/conf.d/cache.conf
EXPOSE 80 81 443 8080
VOLUME /cache
