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

# Get the hostname
HOSTNAME=$(hostname)

# Get the IP address
IP_ADDRESS=$(hostname -I | awk '{print $1}')

# Get the current time
CURRENT_TIME=$(date)

# Write to the index.html file
cat <<EOF > /var/www/html/index.html
<html>
<head>
</head>
<body>
    <h1>Server Information</h1>
    <p><strong>Hostname:</strong> $HOSTNAME</p>
    <p><strong>IP Address:</strong> $IP_ADDRESS</p>
    <p><strong>Build Time:</strong> $CURRENT_TIME</p>
</body>
</html>
EOF
