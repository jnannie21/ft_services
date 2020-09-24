FROM alpine:latest
USER root
ENV TELEGRAF_VERSION 1.15.2

RUN apk update && \
apk add wget && \
rm -rf /var/cache/apk/*

# install telegraf
RUN wget --no-verbose https://dl.influxdata.com/telegraf/releases/telegraf-${TELEGRAF_VERSION}_static_linux_amd64.tar.gz && \
mkdir -p /usr/src /etc/telegraf && \
tar -C /usr/src -xzf telegraf-${TELEGRAF_VERSION}_static_linux_amd64.tar.gz && \
mv /usr/src/telegraf*/etc/telegraf/telegraf.conf /etc/telegraf/ && \
mkdir /etc/telegraf/telegraf.d && \
cp -a /usr/src/telegraf*/usr/bin/telegraf /usr/bin/ && \
rm -rf *.tar.gz* /usr/src

COPY srcs/telegraf.conf /etc/telegraf/telegraf.d/

# script to start services
COPY srcs/start.sh /tmp/
RUN chmod 755 /tmp/start.sh

EXPOSE 8125
CMD /tmp/start.sh
