#!/bin/bash
# Delay to allow Networking and NAT Gateway to stabilize
sleep 180 

# Install Node.js
curl -sL https://rpm.nodesource.com/setup_16.x | bash - 
yum install -y nodejs 

# Create App directory
mkdir -p /var/www/app 
cd /var/www/app 

# Initialize npm and install the MySQL driver locally for the app
npm init -y
npm install mysql2

# Install PM2 GLOBALLY so the system can use it as a service
npm install -g pm2

# Create the server file using the injected Terraform variables
cat <<EOF > app.js
const http = require('http');
const mysql = require('mysql2');

const hostname = '0.0.0.0';
const port = 3000;

// Connect to the RDS Database injected by Terraform
const connection = mysql.createConnection({
  host: '${db_host}',
  user: '${db_user}',
  password: '${db_pass}',
  database: '${db_name}'
});

// Handle connection errors
connection.on('error', function(err) {
  console.error('Database error:', err);
});

const server = http.createServer((req, res) => {
  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/plain');
  
  // Test the database connection
  connection.ping((err) => {
    if (err) {
      res.end('Hello from App Tier! Database Status: DISCONNECTED - ' + err.message);
    } else {
      res.end('Hello from App Tier! Database Status: SUCCESSFULLY CONNECTED to ' + '${db_host}');
    }
  });
});

server.listen(port, hostname, () => {
  console.log('Server running on port ' + port);
});
EOF

# Start the app with PM2 (using npx to bypass strict pathing issues)
npx pm2 start app.js 
npx pm2 startup 
npx pm2 save