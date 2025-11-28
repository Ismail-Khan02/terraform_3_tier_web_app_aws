#!/bin/bash
# Install Node.js (Amazon Linux 2)
curl -sL https://rpm.nodesource.com/setup_16.x | bash -
yum install -y nodejs

# Create a simple App directory
mkdir -p /var/www/app
cd /var/www/app

# Create a simple server file
cat <<EOF > app.js
const http = require('http');
const hostname = '0.0.0.0';
const port = 3000;

const server = http.createServer((req, res) => {
  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/plain');
  res.end('Hello from the Application Layer (Tier 2)!\\n');
});

server.listen(port, hostname, () => {
  console.log('Server running at http://' + hostname + ':' + port + '/');
});
EOF

# Install PM2 to keep the app running
npm install pm2 -g
pm2 start app.js
pm2 startup
pm2 save