#!/bin/bash

# Clone the application repository
git clone https://github-url

# Navigate to the application directory
cd /var/www/your-app

# Install dependencies and build the application
npm install
npm run build

# Restart the application
pm2 restart all || pm2 start ./bin/www --name "your-app"
