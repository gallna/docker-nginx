.PHONY: build push release
.DEFAULT_GOAL := build

build:
	docker pull nginx:latest
	docker build -t gallna/nginx.php-fpm .

push:
	docker tag gallna/nginx.php-fpm gallna/nginx.php-fpm:latest
	docker push gallna/nginx.php-fpm
	docker push gallna/nginx.php-fpm:latest

release: build push
