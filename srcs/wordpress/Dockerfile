FROM alpine:latest
USER root

RUN apk update && \
apk add nginx && \
apk add curl && \
apk add openssl && \
rm -rf /var/cache/apk/*

# ssl
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
-keyout /etc/ssl/private/wordpress.key -out /etc/ssl/certs/wordpress.crt \
-subj "/C=RU/ST=KZ/L=Kazan/O=21School/OU=21kazan/CN=wordpress" && \
# chown nginx:www-data /etc/ssl/private/wordpress.key && \
chown root:root /etc/ssl/private/wordpress.key && \
chmod 400 /etc/ssl/private/wordpress.key

# copy nginx config
COPY srcs/wordpress_nginx.conf /etc/nginx/conf.d/wordpress_nginx.conf
RUN rm -f /etc/nginx/conf.d/default.conf

# wp
RUN mkdir /tmp/wordpress && \
curl -fsSL -o /tmp/wordpress.tar.gz https://wordpress.org/latest.tar.gz && \
tar -xf /tmp/wordpress.tar.gz --strip-components=1 --directory=/tmp/wordpress/ && \
rm /tmp/wordpress.tar.gz

COPY srcs/wp-config-sample.php /tmp/wordpress/wp-config.php

RUN chgrp -R www-data /var/www/ && \
chmod -R 775 /var/www/ && \
mkdir -p /run/nginx

# script to start services
COPY srcs/start.sh /tmp/
RUN chmod 755 /tmp/start.sh

EXPOSE 443
CMD /tmp/start.sh
