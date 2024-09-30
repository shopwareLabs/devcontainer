ARG PHP_VERSION=8.2

FROM friendsofshopware/shopware-cli:latest-php-${PHP_VERSION} as creation
ARG SHOPWARE_VERSION=6.6.3.0

RUN <<EOF
    set -e
    export COMPOSER_ALLOW_SUPERUSER=1
    shopware-cli project create /shop ${SHOPWARE_VERSION}
    shopware-cli project ci /shop
    composer -d /shop require shopware/dev-tools
EOF

COPY --chmod=555 <<EOF /shop/config/packages/override.yaml
parameters:
    env(TRUSTED_PROXIES): ''

framework:
    trusted_proxies: '%env(TRUSTED_PROXIES)%'

shopware:
    auto_update:
        enabled: false
    store:
        frw: false
EOF


FROM ghcr.io/shopware/devcontainer-base-full:${PHP_VERSION}

COPY --from=creation --chown=www-data /shop /var/www/html
COPY --from=friendsofshopware/shopware-cli /usr/local/bin/shopware-cli /usr/local/bin/shopware-cli

RUN <<EOF
    set -e
    /usr/bin/mariadbd --basedir=/usr --datadir=/var/lib/mariadb --plugin-dir=/usr/lib/mariadb/plugin --user=www-data &
    until mariadb-admin ping; do sleep 1; done

    php bin/console system:install --create-database --force
    mariadb -uroot -proot shopware -e "DELETE FROM sales_channel WHERE id = 0x98432def39fc4624b33213a56b8c944d"
    php bin/console user:create "admin" --admin --password="shopware" -n
    php bin/console sales-channel:create:storefront --name=Storefront --url="http://localhost:8000"
    php bin/console theme:change --all Storefront
    mariadb -uroot -proot -e "SET GLOBAL innodb_fast_shutdown=0"
    mariadb -uroot -proot shopware -e "INSERT INTO system_config (id, configuration_key, configuration_value, sales_channel_id, created_at, updated_at) VALUES (0xb3ae4d7111114377af9480c4a0911111, 'core.frw.completedAt', '{\"_value\": \"2019-10-07T10:46:23+00:00\"}', NULL, '2019-10-07 10:46:23.169', NULL);"
    rm -rf var/cache/* /var/tmp/*
    php bin/console
EOF
