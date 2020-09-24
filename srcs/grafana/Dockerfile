FROM alpine:latest
USER root

RUN apk update && \
apk add wget && \
apk add libc6-compat && \
apk add openssl && \
rm -rf /var/cache/apk/*

# install grafana
RUN wget -q https://dl.grafana.com/oss/release/grafana-7.1.5.linux-amd64.tar.gz && \
tar -zxf grafana-7.1.5.linux-amd64.tar.gz && \
rm -f grafana-7.1.5.linux-amd64.tar.gz

# ssl
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
-keyout /grafana-7.1.5/grafana.key -out /grafana-7.1.5/grafana.crt \
-subj "/C=RU/ST=KZ/L=Kazan/O=21School/OU=21kazan/CN=grafana" && \
chown root:root /grafana-7.1.5/grafana.key && \
chmod 400 /grafana-7.1.5/grafana.key

COPY srcs/grafana.db /grafana-7.1.5/data/
COPY srcs/defaults.ini /grafana-7.1.5/conf/

# script to start services
COPY srcs/start.sh /tmp/
RUN chmod 755 /tmp/start.sh

EXPOSE 3000
CMD /tmp/start.sh
