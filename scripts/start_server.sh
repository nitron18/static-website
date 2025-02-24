#!/bin/bash

echo "Starting the web server..."
sudo systemctl restart apache2 || sudo systemctl restart nginx

echo "Deployment completed successfully!"
