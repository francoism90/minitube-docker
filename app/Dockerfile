FROM php:8.1.12-fpm-alpine

ARG USER=me
ARG UID=1000
ARG GID=$UID

WORKDIR /app

RUN apk add --no-cache --virtual .build-deps $PHPIZE_DEPS

RUN apk add --no-cache --virtual .run-deps \
    libcap \
    nodejs \
    npm \
    supervisor \
    libjpeg-turbo-dev \
    libpng-dev \
    libxml2-dev \
    freetype-dev \
    imagemagick-dev \
    zlib-dev \
    jpegoptim \
    optipng \
    pngquant \
    gifsicle \
    ffmpeg \
    && cp "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" \
    && php -r "readfile('https://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer \
    && pecl install imagick \
    && pecl install redis \
    && docker-php-ext-enable imagick \
    && docker-php-ext-enable opcache \
    && docker-php-ext-enable redis \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd \
    && docker-php-ext-install exif \
    && docker-php-ext-install fileinfo \
    && docker-php-ext-install pcntl \
    && docker-php-ext-install simplexml \
    && apk del .build-deps

RUN setcap "cap_net_bind_service=+ep" $(which php) \
    && setcap "cap_net_bind_service=+ep" $(which php-fpm)

RUN adduser \
    --disabled-password \
    --gecos "" \
    --no-create-home \
    --uid "$UID" \
    "$USER"

RUN mkdir -p /data \
    && chown $UID:$GID /data
