FROM alpine:latest
USER root

RUN apk update && \
apk add nginx && \
apk add curl && \
apk add openssl && \
rm -rf /var/cache/apk/*

# ssl
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
-keyout /etc/ssl/private/phpmyadmin.key -out /etc/ssl/certs/phpmyadmin.crt \
-subj "/C=RU/ST=KZ/L=Kazan/O=21School/OU=21kazan/CN=phpmyadmin" && \
# chown nginx:www-data /etc/ssl/private/phpmyadmin.key && \
chown root:root /etc/ssl/private/phpmyadmin.key && \
chmod 400 /etc/ssl/private/phpmyadmin.key

# copy nginx config
COPY srcs/phpmyadmin_nginx.conf /etc/nginx/conf.d/phpmyadmin_nginx.conf
RUN rm -f /etc/nginx/conf.d/default.conf

# phpmyadmin
RUN curl -fsSL -o /tmp/phpMyAdmin.tar.xz https://files.phpmyadmin.net/phpMyAdmin/5.0.2/phpMyAdmin-5.0.2-all-languages.tar.xz && \
mkdir /tmp/phpmyadmin && \
tar -xf /tmp/phpMyAdmin.tar.xz --strip-components=1 --directory=/tmp/phpmyadmin/ && \
rm /tmp/phpMyAdmin.tar.xz

COPY srcs/config.sample.inc.php /tmp/phpmyadmin/config.inc.php

RUN chgrp -R www-data /var/www/ && \
chmod -R 775 /var/www/ && \
mkdir -p /run/nginx

# script to start services
COPY srcs/start.sh /tmp/
RUN chmod 755 /tmp/start.sh

EXPOSE 443
CMD /tmp/start.sh
