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

# Install necessary packages
log "Installing necessary packages..."
sudo yum install -y httpd zip unzip git >> $LOG_FILE 2>&1
log "Necessary packages installed."

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

# Define the GitHub repository URL and the branch
REPO_URL="https://github.com/mercadoalex/frontend-3-tier-terraform-aws.git"
BRANCH="main"

# Define the source directory within the repository and the output zip file
SOURCE_DIR="."  # Use the top level of the repository
OUTPUT_FILE="frontend.zip"

# Define a temporary directory to clone the repository
TEMP_DIR="/tmp/repo"

# Determine the Apache web server directory from the configuration file
APACHE_DIR=$(grep -i '^DocumentRoot' /etc/httpd/conf/httpd.conf | awk '{print $2}' | tr -d '"')

# Log the value of APACHE_DIR
log "APACHE_DIR is $APACHE_DIR"

# Clone the repository
log "Cloning the repository..."
git clone --branch $BRANCH $REPO_URL $TEMP_DIR >> $LOG_FILE 2>&1

# Check if the clone was successful
if [ $? -ne 0 ]; then
  log "Failed to clone the repository."
  exit 1
fi

# Log the contents of the cloned repository
log "Contents of the cloned repository:"
ls -l $TEMP_DIR >> $LOG_FILE 2>&1

# Check if the source directory exists in the cloned repository
if [ -d "$TEMP_DIR/$SOURCE_DIR" ]; then
  # Compress the files in the source directory into the output zip file, excluding .git and .DS_Store files
  log "Compressing the files..."
  zip -r $OUTPUT_FILE $TEMP_DIR/$SOURCE_DIR -x "*.git*" -x "*.DS_Store" >> $LOG_FILE 2>&1

  # Check if the zip command was successful
  if [ $? -eq 0 ]; then
    log "Successfully compressed $SOURCE_DIR into $OUTPUT_FILE"

    # Decompress the zip file in the same TEMP_DIR directory
    log "Decompressing the files in the temporary directory..."
    sudo unzip -o $OUTPUT_FILE -d $TEMP_DIR >> $LOG_FILE 2>&1

    # Check if the unzip command was successful
    if [ $? -eq 0 ]; then
      log "Successfully decompressed $OUTPUT_FILE in $TEMP_DIR"

      # Move the decompressed files to the Apache web server directory
      log "Moving the files to the Apache web server directory..."
      sudo mv $TEMP_DIR/$SOURCE_DIR/* $APACHE_DIR >> $LOG_FILE 2>&1

      # Check if the move command was successful
      if [ $? -eq 0 ]; then
        log "Successfully moved the files to $APACHE_DIR"
      else
        log "Failed to move the files to $APACHE_DIR"
        exit 1
      fi
    else
      log "Failed to decompress $OUTPUT_FILE"
      exit 1
    fi
  else
    log "Failed to compress $SOURCE_DIR"
    exit 1
  fi
else
  log "Source directory $SOURCE_DIR does not exist in the repository."
  exit 1
fi

# Clean up the temporary directory
log "Cleaning up the temporary directory..."
rm -rf $TEMP_DIR

# Clean up the zip file
log "Cleaning up the zip file..."
rm -f $OUTPUT_FILE

log "Web site is ready"
log "Bye Bye"