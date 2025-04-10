FROM cgr.dev/chainguard/wolfi-base:latest

ENV REMOTE_SERVER_HOST=localhost:8000

RUN <<EOF
    apk add --no-cache nginx shadow ca-certificates
    mkdir -p /var/www/html /var/lib/nginx/tmp/client_body
    useradd -r -s /bin/false nginx
    apk del --no-cache shadow
    chown -R nginx /var/www/html /var/lib/nginx/tmp/client_body
EOF

COPY rootfs/ /

EXPOSE 8000
ENTRYPOINT ["/entrypoint"]
CMD ["nginx", "-g", "daemon off;"]