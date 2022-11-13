FROM php:8.1-cli-buster as laravel-cli-base

ARG USER_ID=1000
ARG GROUP_ID=1000

ENV USER_ID=${USER_ID}
ENV GROUP_ID=${GROUP_ID}

MAINTAINER jochem@secretninjas.nl

ENV DEBIAN_FRONTEND noninteractive

# Add group and user based on build arguments
RUN addgroup --gid ${GROUP_ID} ninja \
    && adduser --disabled-password --gecos '' --uid ${USER_ID} --gid ${GROUP_ID} ninja \
    && mkdir -p /code \
    && chown -R ninja:ninja /code

# Add group and user based on build arguments
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
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
     libxml2-dev \
    && docker-php-ext-install  \
     pcntl \
     pdo_mysql \
     zip \
     mbstring \
     fileinfo \
     intl \
     soap \
    && pecl install imagick \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && docker-php-ext-enable imagick \
    && docker-php-ext-configure gd --with-jpeg=/usr/lib --with-freetype=/usr/include/freetype2 \
    && docker-php-ext-install gd \
    && pecl install pcov \
    && docker-php-ext-enable pcov \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set the locale
RUN sed -i -e 's/# \(en_US\.UTF-8 .*\)/\1/' /etc/locale.gen && \
    sed -i -e 's/# \(nl_NL\.UTF-8 .*\)/\1/' /etc/locale.gen && \
    locale-gen

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV LC_TIME nl_NL.UTF-8
