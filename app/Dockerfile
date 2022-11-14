FROM php:8.1.12-fpm-alpine

WORKDIR /data

RUN apk add --no-cache --virtual .build-deps $PHPIZE_DEPS

RUN apk add --no-cache --virtual .run-deps \
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
    && mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" \
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

COPY start-container /usr/local/bin/start-container
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN chmod +x /usr/local/bin/start-container

ENTRYPOINT ["start-container"]

CMD ["php-fpm"]
