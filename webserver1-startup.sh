#!/bin/bash
sudo yum update
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
echo "<h1>WebServer 1</h1><p>Recreating what is in the notebook.</p>" | sudo tee /var/www/html/index.html