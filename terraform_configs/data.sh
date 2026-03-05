#!/bin/bash
# Delay to ensure networking is stable
sleep 300 

# Install Apache
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd

# Create Proxy Configuration
# This forwards traffic from Port 80 to your App Tier via the Internal ALB
cat <<EOF | sudo tee /etc/httpd/conf.d/proxy.conf
<VirtualHost *:80>
    ProxyPreserveHost On
    ProxyPass / http://${internal_alb_dns}:3000/
    ProxyPassReverse / http://${internal_alb_dns}:3000/
</VirtualHost>
EOF

# Restart to apply proxy logic
sudo systemctl restart httpd