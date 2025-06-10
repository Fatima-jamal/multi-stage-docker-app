#!/bin/bash

# Update system packages
yum update -y

# Install Docker
yum install -y docker
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user

# Run Metabase container
docker run -d -p 3000:3000 --name metabase metabase/metabase

# Install and configure NGINX as reverse proxy
yum install -y nginx
systemctl start nginx
systemctl enable nginx

# Create reverse proxy config for Metabase
cat > /etc/nginx/conf.d/metabase.conf <<EOL
server {
    listen 80;
    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOL

# Restart NGINX to load the new config
systemctl restart nginx
