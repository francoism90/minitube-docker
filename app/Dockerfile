FROM php:8.1.12-fpm-alpine

LABEL maintainer="Francois Menning"

ARG USER=me
ARG UID=1000
ARG GID=$USER_UID

RUN adduser \
    --disabled-password \
    --gecos "" \
    --no-create-home \
    --uid "$UID" \
    "$USER"

RUN apk add --no-cache --virtual .build-deps $PHPIZE_DEPS

RUN apk add --no-cache --virtual .run-deps \
    libcap \
    libjpeg-turbo-dev \
    libpng-dev \
    freetype-dev \
    imagemagick-dev \
    zlib-dev \
    jpegoptim \
    optipng \
    pngquant \
    gifsicle \
    ffmpeg \
    && mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" \
    && pecl install imagick \
    && pecl install redis \
    && docker-php-ext-enable imagick \
    && docker-php-ext-enable redis \
    && docker-php-ext-enable opcache \
    && docker-php-ext-enable imagick \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && apk del .build-deps

RUN setcap "cap_net_bind_service=+ep" $(which php) \
    && setcap "cap_net_bind_service=+ep" $(which php-fpm)

USER me
