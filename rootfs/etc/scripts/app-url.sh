#!/usr/bin/env sh

until mariadb-admin ping; do sleep 1; done

if [[ -n $APP_URL ]]; then
  mariadb -uroot -proot shopware -e "UPDATE sales_channel_domain set url = '${APP_URL}'"
fi

echo "Updated sales_channel_domain, sleeping now..."

sleep infinity
