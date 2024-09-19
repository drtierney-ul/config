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

# Create a new Nginx configuration file
cat <<EOL | sudo tee /etc/nginx/sites-available/hello
server {
    listen 80;
    server_name _;

    location / {
        default_type text/html;
        return 200 '
        <!DOCTYPE html>
        <html>
        <head>
            <title>Hello from {hostname}</title>
        </head>
        <body>
            <h1>Hello from \$hostname</h1>
            <p>IP Address: \$remote_addr</p>
            <p>Current Time: \$time_local</p>
        </body>
        </html>';
    }
}
EOL

# Enable the new site by creating a symbolic link
sudo ln -s /etc/nginx/sites-available/hello /etc/nginx/sites-enabled/

# Test the Nginx configuration
sudo nginx -t

# Reload Nginx to apply the changes
sudo systemctl reload nginx

echo "Nginx has been configured and reloaded. Visit your server's IP address to see the message."
