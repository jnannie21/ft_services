FROM alpine:latest
USER root

ARG loadBalancerIP

RUN apk update && \
apk add openssl && \
apk add vsftpd && \
rm -rf /var/cache/apk/*

RUN adduser -D jnannie && \
echo "jnannie:jnannie" | chpasswd && \
mkdir /home/jnannie/ftp && \
chown nobody:nogroup /home/jnannie/ftp && \
chmod a-w /home/jnannie/ftp && \
mkdir /home/jnannie/ftp/files && \
chown jnannie:jnannie /home/jnannie/ftp/files && \
echo "vsftpd test file" | tee /home/jnannie/ftp/files/test.txt

COPY srcs/vsftpd.conf /etc/vsftpd/vsftpd.conf
RUN sed -i "s/pasv_address=loadBalancerIP/pasv_address=$loadBalancerIP/g" /etc/vsftpd/vsftpd.conf

RUN echo "jnannie" | tee -a /etc/vsftpd.userlist

# ssl
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
-keyout /etc/ssl/private/vsftpd.pem -out /etc/ssl/private/vsftpd.pem \
-subj "/C=RU/ST=KZ/L=Kazan/O=21School/OU=21kazan/CN=ftservices"

# script to start services
COPY srcs/start.sh /tmp/
RUN chmod 755 /tmp/start.sh

EXPOSE 20
EXPOSE 21
EXPOSE 21000
CMD /tmp/start.sh
