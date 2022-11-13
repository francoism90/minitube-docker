FROM fedora:latest

LABEL maintainer="Francois Menning"

ARG NGX_VERSION=nginx-1.22.1-1.fc36

RUN useradd -ms /bin/bash -u 1337 www-data
WORKDIR /var/www/html

ENV TZ=UTC

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN echo "fastestmirror=true" >> /etc/dnf/dnf.conf

RUN dnf update -y \
  && dnf install -y curl zip unzip git \
  && dnf install -y ffmpeg-free jpegoptim optipng pngquant gifsicle \
  && dnf install -y nginx nginx-mod-devel \
  && dnf install -y php-cli php-devel php-fpm \
  php-pdo php-mbstring php-json \
  php-xml php-zip php-bcmath php-soap \
  php-intl php-readline \
  php-ldap \
  php-msgpack php-igbinary php-redis \
  php-imagick \
  && mkdir /run/php-fpm \
  && dnf install -y composer \
  && dnf install -y nodejs npm \
  && dnf install -y supervisor

COPY nginx.conf /etc/nginx/nginx.conf
COPY modules /usr/share/nginx/modules
COPY start-container /usr/local/bin/start-container
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN chmod +x /usr/local/bin/start-container

# RUN cd /usr/src \
#   && git clone https://github.com/kaltura/nginx-vod-module.git \
#   && ngx_vod="$(pwd)/nginx-vod-module" \
#   && cd /usr/src/$NGX_VERSION \
#   && ./configure --with-compat --add-dynamic-module=$ngx_vod --with-file-aio --with-threads --with-cc-opt="-O3" \
#   && make \
#   && make install

# RUN cd /usr/src \
#   && git clone https://github.com/kaltura/nginx-secure-token-module.git \
#   && ngx_secure_token="$(pwd)/nginx-secure-token-module" \
#   && cd /usr/src/$NGX_VERSION \
#   && ./configure --with-compat --add-dynamic-module=$ngx_secure_token \
#   && make \
#   && make install

RUN dnf -y autoremove \
  && dnf clean all \
  && rm -rf /tmp/* /var/tmp/*

EXPOSE 80
# EXPOSE 443

ENTRYPOINT ["start-container"]