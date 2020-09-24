FROM alpine:latest
USER root

RUN apk update && \
apk add php php-fpm php-cli php-mysqli php-mbstring php-json php-session && \
rm -rf /var/cache/apk/*

# script to start services
COPY srcs/start.sh /tmp/
RUN chmod 755 /tmp/start.sh

EXPOSE 9000
CMD /tmp/start.sh
