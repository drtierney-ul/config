#!/bin/bash

# Set the DEBIAN_FRONTEND to noninteractive to avoid prompts
#export DEBIAN_FRONTEND=noninteractive
echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Update and upgrade package lists
sudo apt-get update -y
sudo apt-get upgrade -y

# Install Nginx
sudo apt-get install -y nginx

# Enable and start Nginx
sudo systemctl enable nginx
sudo systemctl start nginx

# Create a simple HTML file with "Hello from {hostname}"
echo "Hello from ${HOSTNAME}!" | sudo tee /var/www/html/index.html
