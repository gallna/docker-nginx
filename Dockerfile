FROM nginx:latest

WORKDIR /var/www/public

# Copy configuration
ADD ./nginx.conf /etc/nginx/nginx.conf
ADD ./conf.d/health-check.conf /etc/nginx/conf.d/health-check.conf

EXPOSE 80 81 443
