#!/bin/bash

# Install Nginx
sudo apt-get install -y nginx
systemctl enable nginx
systemctl start nginx

# Create a simple HTML file with "Hello from {hostname}"
echo "Hello from ${HOSTNAME}!" | sudo tee /var/www/html/index.html
