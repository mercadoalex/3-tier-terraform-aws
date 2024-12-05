#!/bin/bash

# Define the log file
LOG_FILE="/var/log/user-data.log"

# Function to log messages
log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> $LOG_FILE
}

# Start logging
log "Starting user data script execution."

# Update the package repository
log "Updating package repository..."
sudo yum update -y >> $LOG_FILE 2>&1
log "Package repository updated."

# Install Apache HTTP server
log "Installing Apache HTTP server..."
sudo yum install -y httpd >> $LOG_FILE 2>&1
log "Apache HTTP server installed."

# Enable Apache to start on boot
log "Enabling Apache to start on boot..."
sudo systemctl enable httpd >> $LOG_FILE 2>&1
log "Apache enabled to start on boot."

# Start Apache service
log "Starting Apache service..."
sudo systemctl start httpd >> $LOG_FILE 2>&1
log "Apache service started."

# Print a message indicating that Apache is installed and running
log "Apache server installed and running."

# Calling the script compress-site.sh
log "Calling compress-site.sh..."
./compress-site.sh >> $LOG_FILE 2>&1

# Check if the first script (compress-site.sh) executed successfully
if [ $? -eq 0 ]; then
  log "compress-site.sh executed successfully."

# Call the second script (decompress-upload-website.sh)
  log "Calling decompress-upload-website.sh..."
  ./decompress-upload-website.sh >> $LOG_FILE 2>&1

  # Check if the second script executed successfully
  if [ $? -eq 0 ]; then
    log "decompress-upload-website.sh executed successfully."
  else
    log "decompress-upload-website.sh failed."
  fi
else
  log "compress-site.sh failed. Skipping decompress-upload-website.sh."
fi
