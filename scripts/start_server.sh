#!/bin/bash
exec > /var/log/start_server.log 2>&1  # Log output for debugging

echo "### Stopping Apache (if running)..."
sudo systemctl stop apache2 || true

echo "### Setting correct permissions for /var/www/html/..."
sudo chown -R www-data:www-data /var/www/html/
sudo chmod -R 755 /var/www/html/

echo "### Starting Apache web server..."
sudo systemctl start apache2
sudo systemctl enable apache2

echo "### Apache restarted successfully!"
