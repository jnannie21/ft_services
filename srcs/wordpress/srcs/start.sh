#!/bin/sh
cp -r /tmp/wordpress /var/www/
nginx -g 'daemon off;'
