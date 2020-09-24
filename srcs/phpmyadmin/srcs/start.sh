#!/bin/sh
cp -r /tmp/phpmyadmin /var/www/
nginx -g 'daemon off;'
