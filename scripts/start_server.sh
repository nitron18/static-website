#!/bin/bash
echo "Starting Simple Web Server"
nohup python3 -m http.server 80 --directory /var/www/html > /var/www/html/server.log 2>&1 &