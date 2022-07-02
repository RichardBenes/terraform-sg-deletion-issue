#!/bin/bash
sudo yum update
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
echo "<h1>WebServer 3</h1><p>Modularizing.</p>" | sudo tee /var/www/html/index.html