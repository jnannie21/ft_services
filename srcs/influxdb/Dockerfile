FROM alpine:latest
USER root

RUN apk add --no-cache influxdb;

# script to start services
COPY srcs/start.sh /tmp/
RUN chmod 755 /tmp/start.sh

EXPOSE 8086
CMD /tmp/start.sh
