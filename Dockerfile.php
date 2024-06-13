ARG PHP_VERSION=8.3

FROM ghcr.io/shyim/wolfi-php/nginx:${PHP_VERSION}

ARG PHP_VERSION=8.3

ENV DATABASE_URL=mysql://root:root@localhost/shopware \
    LOCK_DSN=flock \
    PHP_MEMORY_LIMIT=512M \
    COMPOSER_ROOT_VERSION=1.0.0 \
    APP_URL=http://localhost:8000 \
    NPM_CONFIG_ENGINE_STRICT=false

RUN <<EOF
    set -e

    apk add --no-cache \
        libstdc++ \
        bash \
        bash-completion \
        valkey \
        valkey-cli \
        curl \
        nodejs-22 \
        npm \
        git \
        composer \
        php-${PHP_VERSION} \
        php-${PHP_VERSION}-fileinfo \
        php-${PHP_VERSION}-openssl \
        php-${PHP_VERSION}-ctype \
        php-${PHP_VERSION}-curl \
        php-${PHP_VERSION}-xml \
        php-${PHP_VERSION}-dom \
        php-${PHP_VERSION}-phar \
        php-${PHP_VERSION}-simplexml \
        php-${PHP_VERSION}-xmlreader \
        php-${PHP_VERSION}-xmlwriter \
        php-${PHP_VERSION}-bcmath \
        php-${PHP_VERSION}-iconv \
        php-${PHP_VERSION}-mbstring \
        php-${PHP_VERSION}-gd \
        php-${PHP_VERSION}-intl \
        php-${PHP_VERSION}-pdo \
        php-${PHP_VERSION}-pdo_mysql \
        php-${PHP_VERSION}-mysqlnd \
        php-${PHP_VERSION}-pcntl \
        php-${PHP_VERSION}-sockets \
        php-${PHP_VERSION}-bz2 \
        php-${PHP_VERSION}-gmp \
        php-${PHP_VERSION}-soap \
        php-${PHP_VERSION}-zip \
        php-${PHP_VERSION}-sodium \
        php-${PHP_VERSION}-opcache \
        php-${PHP_VERSION}-zstd \
        php-${PHP_VERSION}-redis \
        php-${PHP_VERSION}-imagick \
        openssl-config \
        mariadb-11.2 \
        jq

    mkdir -p /var/tmp /run/mysqld
    mariadb-install-db --datadir=/var/lib/mariadb --user=root
    /usr/bin/mariadbd --basedir=/usr --datadir=/var/lib/mariadb --plugin-dir=/usr/lib/mariadb/plugin --user=root &
    sleep 2
    mariadb-admin --user=root password 'root'
    chown -R www-data:www-data /var/www/html /var/lib/mariadb/ /var/tmp /run/mysqld/

    ldconfig
EOF

COPY rootfs /

USER www-data
