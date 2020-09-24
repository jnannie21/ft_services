FROM alpine:latest
USER root

RUN apk update &&\
apk add nginx && \
apk add curl && \
apk add openssl && \
apk add openssh && \
rm -rf /var/cache/apk/*

# ssl
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
-keyout /etc/ssl/private/nginx.key -out /etc/ssl/certs/nginx.crt \
-subj "/C=RU/ST=KZ/L=Kazan/O=21School/OU=21kazan/CN=nginx" && \
# chown nginx:www-data /etc/ssl/private/nginx.key && \
chown root:root /etc/ssl/private/nginx.key && \
chmod 400 /etc/ssl/private/nginx.key

# ssh
RUN adduser -D jnannie && \
echo "jnannie:jnannie" | chpasswd && \
ssh-keygen -A

# copy nginx config
COPY srcs/nginx.conf /etc/nginx/conf.d/nginx.conf
RUN rm -f /etc/nginx/conf.d/default.conf

RUN chgrp -R www-data /var/www/ && \
chmod -R 775 /var/www/ && \
mkdir -p /run/nginx

# script to start services
COPY srcs/start.sh /tmp/
COPY srcs/index.html /var/www/
RUN chmod 755 /tmp/start.sh

EXPOSE 80
EXPOSE 443
EXPOSE 22
CMD /tmp/start.sh
