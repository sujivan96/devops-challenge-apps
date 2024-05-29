#!/bin/bash

# Update and install required packages
sudo apt-get update
sudo apt-get install -y curl gnupg2 ca-certificates lsb-release software-properties-common

# Install Node.js and NPM
curl -fsSL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install Nginx
sudo apt-get install -y nginx

# Configure Nginx for web.example.com
sudo bash -c 'cat <<EOF > /etc/nginx/sites-available/web.example.com
server {
    listen 80;
    server_name web.example.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF'

# Configure Nginx for api.example.com
sudo bash -c 'cat <<EOF > /etc/nginx/sites-available/api.example.com
server {
    listen 80;
    server_name api.example.com;

    location / {
        proxy_pass http://localhost:4000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF'

# Enable the Nginx configurations
sudo ln -s /etc/nginx/sites-available/web.example.com /etc/nginx/sites-enabled/
sudo ln -s /etc/nginx/sites-available/api.example.com /etc/nginx/sites-enabled/
sudo systemctl restart nginx

# Install Certbot and obtain SSL certificates
sudo apt-get install -y certbot python3-certbot-nginx
sudo certbot --nginx -d web.example.com -d api.example.com --non-interactive --agree-tos -m your-email@example.com