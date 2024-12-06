#!/bin/bash

# Define the key pair name
KEY_NAME="la_maldita_llave"

# Define the directory to store the keys
KEY_DIR="keys"

# Create the directory if it doesn't exist
mkdir -p $KEY_DIR

# Generate the RSA private key with a .pem extension
ssh-keygen -t rsa -b 2048 -f $KEY_DIR/$KEY_NAME -q -N ""

# Move the private key to have a .pem extension
mv $KEY_DIR/$KEY_NAME $KEY_DIR/$KEY_NAME.pem

# The public key is already created with a .pub extension by ssh-keygen
# Output the location of the keys
echo "Private key: $KEY_DIR/$KEY_NAME.pem"
echo "Public key: $KEY_DIR/$KEY_NAME.pub"