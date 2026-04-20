#!/bin/bash
# FIX 1: Install Node.js 20.x (Current LTS) instead of End-of-Life 16.x
curl -sL https://rpm.nodesource.com/setup_20.x | bash -
yum install -y nodejs awscli

# Fetch DB credentials from Secrets Manager at runtime
SECRET=$(aws secretsmanager get-secret-value \
  --secret-id "${secret_id}" \
  --region ${aws_region} \
  --query SecretString \
  --output text)

# Parse username and password from the JSON secret
DB_USER=$(echo $SECRET | python3 -c "import sys, json; print(json.load(sys.stdin)['username'])")
DB_PASS=$(echo $SECRET | python3 -c "import sys, json; print(json.load(sys.stdin)['password'])")

# Create App directory
mkdir -p /var/www/app
cd /var/www/app

# Initialize npm and install dependencies
npm init -y
npm install mysql2

# Install PM2 GLOBALLY so the system can use it as a service
npm install -g pm2

# Write the application code securely
cat << 'APPEOF' > app.js
const http = require('http');
const mysql = require('mysql2/promise');

const hostname = '0.0.0.0';
const port = 3000;

// Connection pool using env vars injected at PM2 start
const pool = mysql.createPool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASS,
  database: process.env.DB_NAME,
  waitForConnections: true,
  connectionLimit: 10,
});

// Create tables if they don't exist
async function initDB() {
  const conn = await pool.getConnection();
  await conn.execute(`
    CREATE TABLE IF NOT EXISTS visitors (
      id INT AUTO_INCREMENT PRIMARY KEY,
      count INT NOT NULL DEFAULT 0
    )
  `);
  await conn.execute(`
    INSERT INTO visitors (count)
    SELECT 0 WHERE NOT EXISTS (SELECT 1 FROM visitors)
  `);
  await conn.execute(`
    CREATE TABLE IF NOT EXISTS guestbook (
      id INT AUTO_INCREMENT PRIMARY KEY,
      name VARCHAR(100) NOT NULL,
      message VARCHAR(500) NOT NULL,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )
  `);
  conn.release();
  console.log('Database initialised successfully');
}

// Parse request body helper
function parseBody(req) {
  return new Promise((resolve, reject) => {
    let body = '';
    req.on('data', chunk => body += chunk.toString());
    req.on('end', () => {
      try { resolve(JSON.parse(body)); }
      catch { resolve({}); }
    });
    req.on('error', reject);
  });
}

// HTML frontend
function serveFrontend(res) {
  res.writeHead(200, { 'Content-Type': 'text/html' });
  res.end(`<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Guestbook</title>
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body { font-family: Arial, sans-serif; background: #f0f2f5; color: #333; padding: 30px; }
    .container { max-width: 700px; margin: 0 auto; }
    h1 { text-align: center; margin-bottom: 8px; color: #2c3e50; }
    .visitor-count { text-align: center; color: #7f8c8d; margin-bottom: 30px; font-size: 14px; }
    .card { background: white; border-radius: 10px; padding: 24px; margin-bottom: 24px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
    h2 { margin-bottom: 16px; color: #2c3e50; font-size: 18px; }
    input, textarea { width: 100%; padding: 10px 14px; margin-bottom: 12px; border: 1px solid #ddd; border-radius: 6px; font-size: 15px; }
    textarea { height: 90px; resize: vertical; }
    button { background: #3498db; color: white; border: none; padding: 10px 24px; border-radius: 6px; font-size: 15px; cursor: pointer; width: 100%; }
    button:hover { background: #2980b9; }
    #status { margin-top: 10px; font-size: 14px; text-align: center; min-height: 20px; }
    .entry { border-bottom: 1px solid #f0f0f0; padding: 14px 0; }
    .entry:last-child { border-bottom: none; }
    .entry-name { font-weight: bold; color: #2c3e50; }
    .entry-time { font-size: 12px; color: #aaa; margin-left: 8px; }
    .entry-msg { margin-top: 6px; line-height: 1.5; }
    #entries { min-height: 40px; }
    .empty { color: #aaa; text-align: center; padding: 20px 0; font-size: 14px; }
  </style>
</head>
<body>
  <div class="container">
    <h1>Guestbook</h1>
    <p class="visitor-count" id="visitorCount">Loading visitor count...</p>
    <div class="card">
      <h2>Leave a Message</h2>
      <input type="text" id="name" placeholder="Your name" maxlength="100" />
      <textarea id="message" placeholder="Write your message here..." maxlength="500"></textarea>
      <button onclick="submitEntry()">Sign Guestbook</button>
      <p id="status"></p>
    </div>
    <div class="card">
      <h2>Messages</h2>
      <div id="entries"><p class="empty">Loading messages...</p></div>
    </div>
  </div>
  <script>
    async function loadData() {
      try {
        const [visitorRes, entriesRes] = await Promise.all([fetch('/visitors'), fetch('/entries')]);
        const { count } = await visitorRes.json();
        const entries = await entriesRes.json();
        document.getElementById('visitorCount').textContent = count + ' total visit' + (count !== 1 ? 's' : '');
        const container = document.getElementById('entries');
        if (entries.length === 0) {
          container.innerHTML = '<p class="empty">No messages yet. Be the first to sign!</p>';
        } else {
          container.innerHTML = entries.map(e =>
            '<div class="entry"><span class="entry-name">' + escapeHtml(e.name) + '</span>' +
            '<span class="entry-time">' + new Date(e.created_at).toLocaleString() + '</span>' +
            '<p class="entry-msg">' + escapeHtml(e.message) + '</p></div>'
          ).join('');
        }
      } catch (err) { console.error('Error loading data:', err); }
    }
    async function submitEntry() {
      const name = document.getElementById('name').value.trim();
      const message = document.getElementById('message').value.trim();
      const status = document.getElementById('status');
      if (!name || !message) {
        status.style.color = '#e74c3c';
        status.textContent = 'Please fill in both your name and a message.';
        return;
      }
      try {
        const res = await fetch('/sign', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ name, message })
        });
        if (res.ok) {
          status.style.color = '#27ae60';
          status.textContent = 'Message added successfully!';
          document.getElementById('name').value = '';
          document.getElementById('message').value = '';
          await loadData();
        } else {
          status.style.color = '#e74c3c';
          status.textContent = 'Something went wrong. Please try again.';
        }
      } catch (err) {
        status.style.color = '#e74c3c';
        status.textContent = 'Could not connect to server.';
      }
      setTimeout(() => status.textContent = '', 4000);
    }
    function escapeHtml(str) {
      return str.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;')
                .replace(/"/g,'&quot;').replace(/'/g,'&#039;');
    }
    loadData();
  </script>
</body>
</html>`);
}

const server = http.createServer(async (req, res) => {
  if (req.method === 'GET' && req.url === '/') {
    try { await pool.execute('UPDATE visitors SET count = count + 1 WHERE id = 1'); }
    catch (err) { console.error('Visitor count error:', err); }
    return serveFrontend(res);
  }
  if (req.method === 'GET' && req.url === '/visitors') {
    try {
      const [rows] = await pool.execute('SELECT count FROM visitors WHERE id = 1');
      res.writeHead(200, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify({ count: rows[0].count }));
    } catch (err) {
      res.writeHead(500, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify({ error: err.message }));
    }
    return;
  }
  if (req.method === 'GET' && req.url === '/entries') {
    try {
      const [rows] = await pool.execute('SELECT name, message, created_at FROM guestbook ORDER BY created_at DESC');
      res.writeHead(200, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify(rows));
    } catch (err) {
      res.writeHead(500, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify({ error: err.message }));
    }
    return;
  }
  if (req.method === 'POST' && req.url === '/sign') {
    try {
      const { name, message } = await parseBody(req);
      if (!name || !message) {
        res.writeHead(400, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ error: 'Name and message are required' }));
        return;
      }
      await pool.execute('INSERT INTO guestbook (name, message) VALUES (?, ?)',
        [name.substring(0, 100), message.substring(0, 500)]);
      res.writeHead(201, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify({ success: true }));
    } catch (err) {
      res.writeHead(500, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify({ error: err.message }));
    }
    return;
  }
  res.writeHead(404, { 'Content-Type': 'application/json' });
  res.end(JSON.stringify({ error: 'Not found' }));
});

initDB()
  .then(() => server.listen(port, hostname, () => console.log('Guestbook app running on port ' + port)))
  .catch(err => { console.error('Failed to initialise database:', err); process.exit(1); });
APPEOF

# FIX 2: Stop the Process List Secret Leak using an Ecosystem file
# We dynamically generate a PM2 config file and inject variables cleanly.
# Notice we DO NOT quote 'EOF' here, so bash evaluates $DB_USER and $DB_PASS.
cat << ECOSYSTEM_EOF > ecosystem.config.js
module.exports = {
  apps : [{
    name   : "guestbook-app",
    script : "app.js",
    env: {
      DB_HOST: "${db_host}",
      DB_USER: "$DB_USER",
      DB_PASS: "$DB_PASS",
      DB_NAME: "${db_name}"
    }
  }]
}
ECOSYSTEM_EOF

# FIX 3: Lock down the secrets file so only the root user can read it
chmod 600 ecosystem.config.js

# FIX 4: Start PM2 using the secure config and ensure reliable reboot survival
pm2 start ecosystem.config.js
pm2 startup systemd -u root --hp /root
pm2 save