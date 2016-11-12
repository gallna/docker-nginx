# NGINX container configured to work with PHP-FPM

Images build on top of official *nginx* image.

## Features

Server expects php-fpm host on port 9000

Port configuration:

 - 80 configured to handle php-fpm requests
 - 81 configured to handle php-fpm [ping and status](https://easyengine.io/tutorials/php/fpm-status-page/) requests
    - **http://nginx:81/ping**
    - **http://nginx:81/status**

## Example

```
docker run --name official-php-fpm -p 9000:9000 php:fpm

docker run --name nginx -p 80:80 -p 81:81 \
    --link official-php-fpm:php-fpm \
    gallna/docker-nginx
```

Open [http://localhost](http://localhost) to see content
Open [http://localhost:81/status](http://localhost:81/status) to see php status page
Open [http://localhost:81/ping](http://localhost:81/ping) to health-check php
