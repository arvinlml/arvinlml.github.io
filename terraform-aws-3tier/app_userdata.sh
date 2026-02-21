#!/bin/bash
set -e

# Update system
yum update -y
yum install -y nodejs npm git

# Create app directory
mkdir -p /opt/myapp
cd /opt/myapp

# Create package.json
cat > package.json <<'EOFJSON'
{
  "name": "3tier-app",
  "version": "1.0.0",
  "description": "Simple 3-tier application",
  "main": "server.js",
  "scripts": {
    "start": "node server.js"
  },
  "dependencies": {
    "express": "^4.18.2",
    "mysql": "^2.18.1"
  }
}
EOFJSON

# Install dependencies
npm install

# Create server.js
cat > server.js <<'EOFJS'
const express = require('express');
const mysql = require('mysql');

const app = express();
const port = 8080;
const dbHost = '${db_host}'.split(':')[0];  // Remove port if included

console.log('Attempting to connect to database at:', dbHost);

const connection = mysql.createConnection({
  host: dbHost,
  user: 'admin',
  password: 'ChangeMe123!',  // Use the same password from Terraform
  database: 'appdb'
});

connection.connect((err) => {
  if (err) {
    console.error('Database connection failed:', err);
    process.exit(1);
  }
  console.log('Connected to MySQL database!');
});

app.get('/', (req, res) => {
  connection.query('SELECT @@version as version', (err, results) => {
    if (err) {
      console.error('Query error:', err);
      res.send(`<h1>3-Tier Application</h1><p>Database Error: ${err.message}</p>`);
      return;
    }
    
    const dbVersion = results[0].version;
    const hostname = require('os').hostname();
    
    res.send(`
      <html>
        <head>
          <title>3-Tier Application</title>
          <style>
            body { font-family: Arial, sans-serif; margin: 40px; }
            .container { max-width: 600px; margin: 0 auto; }
            .info { background: #f0f0f0; padding: 20px; border-radius: 5px; }
            .status { color: #28a745; font-weight: bold; }
          </style>
        </head>
        <body>
          <div class="container">
            <h1>🎉 3-Tier Application Running!</h1>
            <div class="info">
              <p><strong>App Instance:</strong> ${hostname}</p>
              <p><strong>Database Status:</strong> <span class="status">✓ Connected</span></p>
              <p><strong>Database Version:</strong> ${dbVersion}</p>
              <p><strong>Server Port:</strong> 8080</p>
            </div>
            <h2>Architecture</h2>
            <ul>
              <li><strong>Web Tier:</strong> ALB distributing traffic</li>
              <li><strong>App Tier:</strong> 2 EC2 instances (this is one of them)</li>
              <li><strong>Database Tier:</strong> MySQL RDS (Multi-AZ)</li>
            </ul>
          </div>
        </body>
      </html>
    `);
  });
});

app.listen(port, () => {
  console.log(\`Server running on port \${port}\`);
});
EOFJS

# Start the application with systemd
cat > /etc/systemd/system/myapp.service <<'EOFSVC'
[Unit]
Description=3-Tier Application
After=network.target

[Service]
Type=simple
User=ec2-user
WorkingDirectory=/opt/myapp
ExecStart=/usr/bin/node /opt/myapp/server.js
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOFSVC

systemctl daemon-reload
systemctl enable myapp
systemctl start myapp

echo "Application setup complete!"
