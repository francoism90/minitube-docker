FROM nginxinc/nginx-unprivileged:mainline-alpine AS builder

USER root

WORKDIR /usr/local/src

RUN wget "http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz" -O nginx.tar.gz

RUN apk add --no-cache --virtual .build-deps \
    git \
    gcc \
    libc-dev \
    make \
    openssl-dev \
    pcre2-dev \
    zlib-dev \
    linux-headers \
    libxslt-dev \
    gd-dev \
    geoip-dev \
    perl-dev \
    libedit-dev \
    bash \
    alpine-sdk \
    findutils \
    ffmpeg-dev \
    ffmpeg \
    ffmpeg-libs

RUN set -x \
    && tar xzvf nginx.tar.gz \
    && mv /usr/local/src/nginx-${NGINX_VERSION} /usr/local/src/nginx

RUN cd /usr/local/src \
    && git clone --depth 1 https://github.com/kaltura/nginx-vod-module.git \
    && MODULEDIR=$(pwd)/nginx-vod-module \
    && cd /usr/local/src/nginx \
    && ./configure --with-compat $CONFARGS --add-dynamic-module=$MODULEDIR --with-debug --with-file-aio --with-threads --with-cc-opt="-O3" \
    && make \
    && make install

RUN cd /usr/local/src \
    && git clone --depth 1 https://github.com/kaltura/nginx-secure-token-module.git \
    && MODULEDIR=$(pwd)/nginx-secure-token-module \
    && cd /usr/local/src/nginx \
    && ./configure --with-compat $CONFARGS --add-dynamic-module=$MODULEDIR --with-debug --with-cc-opt="-O3" \
    && make \
    && make install \
    && apk del .build-deps

FROM nginxinc/nginx-unprivileged:mainline-alpine

USER root

COPY --from=builder /usr/local/nginx/modules/ngx_http_vod_module.so /usr/local/nginx/modules/ngx_http_vod_module.so
COPY --from=builder /usr/local/nginx/modules/ngx_http_secure_token_filter_module.so /usr/local/nginx/modules/ngx_http_secure_token_filter_module.so

RUN apk add --no-cache --virtual .run-deps \
    ffmpeg \
    ffmpeg-libs

EXPOSE 8080
EXPOSE 4443

STOPSIGNAL SIGQUIT

USER $UID

CMD ["nginx", "-g", "daemon off;"]
