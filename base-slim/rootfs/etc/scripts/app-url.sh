#!/usr/bin/env sh

wait-for-mysql

if [[ -n $CODESPACE_NAME ]]; then
  echo "Detected GitHub Codespace"
  export APP_URL="https://${CODESPACE_NAME}-8000.app.github.dev"
fi

if [[ -n $APP_URL ]]; then
  mariadb -uroot -proot shopware -e "UPDATE sales_channel_domain set url = '${APP_URL}'"
  rm -rf /var/www/html/var/cache
fi

if [ -n "$1" ] && [ "$1" = "sleep" ]; then
  echo "Updated sales_channel_domain, sleeping now..."
  sleep infinity
fi
