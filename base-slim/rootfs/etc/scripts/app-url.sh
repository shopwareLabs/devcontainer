#!/usr/bin/env sh

until mariadb -e 'select 1'; do sleep 1; done

if [[ -n $APP_URL ]]; then
  mariadb -uroot -proot shopware -e "UPDATE sales_channel_domain set url = '${APP_URL}'"
  rm -rf /var/www/html/var/cache
fi

echo "Updated sales_channel_domain, sleeping now..."

sleep infinity
