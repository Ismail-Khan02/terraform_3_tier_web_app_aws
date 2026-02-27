#!/bin/bash
# Artificial delay to ensure networking/NAT Gateway is fully stable
sleep 30

# Install Apache (httpd)
sudo dnf install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd

# Create a Reverse Proxy configuration
# This sends all traffic from Port 80 on this Web Server to the Internal ALB
cat <<EOF | sudo tee /etc/httpd/conf.d/proxy.conf
<VirtualHost *:80>
    ProxyPreserveHost On
    # Forwarding to the Internal ALB which handles the App Tier
    ProxyPass / http://${internal_alb_dns}/
    ProxyPassReverse / http://${internal_alb_dns}/
</VirtualHost>
EOF

# Restart Apache to apply the proxy settings
sudo systemctl restart httpd