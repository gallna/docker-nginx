FROM nginx:1.12

WORKDIR /var/www/public
EXPOSE 80 81 443
COPY nginx /etc/nginx/
