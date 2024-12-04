#!/bin/bash
# Update the package repository
sudo yum update -y

# Install Apache HTTP server
sudo yum install -y httpd

# Enable Apache to start on boot
sudo systemctl enable httpd

# Start Apache service
sudo systemctl start httpd

# Print a message indicating that Apache is installed and running
echo "Servidor Apache instalado y corriendo"