FROM alpine:latest

LABEL maintainer="Popov Gennady <gennadiy.popov.87@yandex.ru>"

# Install system dependencies
RUN apk --update --no-cache add zip unzip runit wget curl git ca-certificates php7 bash nodejs-current libcap npm \
    php7-phar php7-iconv libpng-dev php7-pear php7-cli php7-ctype php7-dev php7-fpm php7-mbstring \
    php7-pdo php7-pdo_sqlite php7-json php7-curl php7-openssl php7-gd php7-zip php7-mongodb

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer 

# Install http daemon
RUN wget https://getcaddy.com -O getcaddy && \
    chmod +x getcaddy && \
    ./getcaddy personal http.ipfilter,http.ratelimit

# Allow caddy to use standard internal network post
RUN  setcap cap_net_bind_service=+ep /usr/local/bin/caddy


WORKDIR /var/www/html

RUN git clone https://github.com/agentejo/cockpit .
RUN npm install && npm run build && composer install

COPY services /etc/service/
CMD ["runsvdir", "/etc/service"]
