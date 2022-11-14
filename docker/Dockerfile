FROM nginx:alpine AS builder

WORKDIR /tmp

RUN wget "http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz" -O nginx.tar.gz \
    && wget "https://github.com/kaltura/nginx-vod-module/archive/master.tar.gz" -O kaltura-nginx-vod.tar.gz \
    && wget "https://github.com/kaltura/nginx-secure-token-module/archive/master.tar.gz" -O kaltura-nginx-secure-token.tar.gz

RUN apk add --no-cache --virtual .build-deps \
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
    ffmpeg

RUN set -x \
    && tar xzvf nginx.tar.gz \
    && tar xzvf kaltura-nginx-vod.tar.gz \
    && tar xzvf kaltura-nginx-secure-token.tar.gz \
    && export MODULEDIR="$(pwd)/kaltura-nginx-vod"

RUN cd /tmp/nginx-${NGINX_VERSION} \
    && ./configure --with-compat $CONFARGS --add-dynamic-module=$MODULEDIR --with-file-aio --with-threads --with-cc-opt="-O3" \
    && make \
    && make install

# RUN cd /tmp/nginx-${NGINX_VERSION} \
#     && ./configure --with-compat $CONFARGS --add-dynamic-module="$MODULEDIR/kaltura-nginx-secure-token" --with-cc-opt="-O3" \
#     && make \
#     && make install

# FROM nginx:alpine
# COPY --from=builder /usr/local/nginx/modules/ngx_vod_module.so /usr/local/nginx/modules/ngx_vod_module.so

# EXPOSE 80
# EXPOSE 443

# STOPSIGNAL SIGQUIT

# CMD ["nginx", "-g", "daemon off;"]
