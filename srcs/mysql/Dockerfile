FROM alpine:latest
USER root

RUN apk update && \
apk add mysql mysql-client && \
rm -rf /var/cache/apk/*

COPY srcs/start.sh /tmp/
RUN chmod 755 /tmp/start.sh

EXPOSE 3306
CMD /tmp/start.sh
