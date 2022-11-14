FROM composer:2 as composer-base
FROM php:8.1-fpm-buster as laravel-fpm-base

ARG COMPOSER_AUTH
ARG USER_ID=1000
ARG GROUP_ID=1000

ENV USER_ID=${USER_ID}
ENV GROUP_ID=${GROUP_ID}
ENV COMPOSER_AUTH=${COMPOSER_AUTH}

MAINTAINER jochem@secretninjas.nl

WORKDIR /code

ENV DEBIAN_FRONTEND noninteractive

# Add group and user based on build arguments
RUN addgroup --gid ${GROUP_ID} ninja \
    && adduser --disabled-password --gecos '' --uid ${USER_ID} --gid ${GROUP_ID} ninja \
    && mkdir -p /code \
    && chown -R ninja:ninja /code

# Add group and user based on build arguments
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
     git \
     locales  \
     jpegoptim \
     optipng \
     pngquant \
     gifsicle \
     ffmpeg \
     default-mysql-client \
     libonig-dev \
     libmagickwand-dev \
     libzip-dev \
     zip\
     libcap2-bin \
     libxml2-dev \
    && docker-php-ext-install  \
     pcntl \
     pdo_mysql \
     zip \
     mbstring \
     fileinfo \
     intl \
     soap \
     opcache \
    && pecl install imagick \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && docker-php-ext-enable opcache \
    && docker-php-ext-enable imagick \
    && docker-php-ext-configure gd --with-jpeg=/usr/lib --with-freetype=/usr/include/freetype2 \
    && docker-php-ext-install gd \
    && pecl install pcov \
    && docker-php-ext-enable pcov \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN setcap "cap_net_bind_service=+ep" /usr/local/bin/php \
    && setcap "cap_net_bind_service=+ep" $(which php-fpm)

# Set the locale
RUN sed -i -e 's/# \(en_US\.UTF-8 .*\)/\1/' /etc/locale.gen && \
    sed -i -e 's/# \(nl_NL\.UTF-8 .*\)/\1/' /etc/locale.gen && \
    locale-gen

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV LC_TIME nl_NL.UTF-8

USER ninja
