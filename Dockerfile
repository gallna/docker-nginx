FROM nginx:1.12

WORKDIR /var/www/public
EXPOSE 80 81 443
COPY nginx /etc/nginx/

RUN echo "deb-src http://nginx.org/packages/mainline/debian/ stretch nginx" >> /etc/apt/sources.list \
      && apt-get update \
    && apt-get --yes install --no-install-recommends --no-install-suggests ca-certificates curl libxslt-dev libxml2-dev \
    && apt-get --yes build-dep nginx \
    && apt-get --yes source nginx \
    && cd nginx-* \
    && mkdir ngx_aws_auth \
    && curl -qL https://github.com/anomalizer/ngx_aws_auth/archive/2.1.1.tar.gz | tar -xz --strip=1 -C ./ngx_aws_auth \
    && sed -i -e 's/--with-http_ssl_module/--with-http_ssl_module --with-http_xslt_module --add-module=$(CURDIR)\/ngx_aws_auth/g' debian/rules \
    && dpkg-buildpackage -b \
    && dpkg --install ../nginx_*.deb

ENTRYPOINT /etc/nginx/bin/entrypoint.sh
