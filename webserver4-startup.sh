#!/bin/bash
sudo yum update
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
echo "<h1>WebServer 4</h1><p>Modularizing in Yellow.</p>" | sudo tee /var/www/html/index.html