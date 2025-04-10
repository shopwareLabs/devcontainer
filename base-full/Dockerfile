ARG PHP_VERSION=8.3

FROM base

ARG PHP_VERSION=8.3
ARG TARGETARCH

ENV DATABASE_URL=mysql://root:root@localhost/shopware \
    MAILER_DSN=smtp://localhost:1025

RUN --mount=type=cache,id=apk-${TARGETARCH},sharing=locked,target=/var/cache/apk <<EOF
    set -e

    sudo ln -s /var/cache/apk /etc/apk/cache

    sudo apk update
    sudo apk upgrade

    sudo apk add \
        valkey \
        mariadb-11.2 \
        mailpit

    sudo rm /etc/apk/cache

    echo "mariadb: /usr/bin/mariadbd --basedir=/usr --datadir=/var/lib/mariadb --plugin-dir=/usr/lib/mariadb/plugin --user=www-data" | sudo tee -a /etc/Procfile
    echo "valkey: /usr/bin/valkey-server --dir /tmp" | sudo tee -a /etc/Procfile
    echo "mailpit: /usr/bin/mailpit --db-file /tmp/mailpit.db" | sudo tee -a /etc/Procfile
    echo "maintenance: /etc/scripts/app-url.sh sleep" | sudo tee -a /etc/Procfile

    echo -e "[client]\nuser=root\npassword=root\nhost=127.0.0.1" > /home/www-data/.my.cnf

    sudo mkdir -p /var/tmp /run/mysqld /var/lib/mariadb
    sudo chown -R www-data:www-data /var/tmp /run/mysqld /var/lib/mariadb

    mariadb-install-db --datadir=/var/lib/mariadb
    /usr/bin/mariadbd --basedir=/usr --datadir=/var/lib/mariadb --plugin-dir=/usr/lib/mariadb/plugin --skip-networking &

    until mariadb-admin --no-defaults ping; do sleep 1; done

    sudo mariadb-admin --no-defaults --user=root password 'root'
EOF
