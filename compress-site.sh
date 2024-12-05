#!/bin/bash

# Define the source directory and the output zip file
SOURCE_DIR="frontend"
OUTPUT_FILE="frontend.zip"

# Check if the source directory exists
if [ -d "$SOURCE_DIR" ]; then
  # Compress the files in the source directory into the output zip file
  zip -r $OUTPUT_FILE $SOURCE_DIR

  # Check if the zip command was successful
  if [ $? -eq 0 ]; then
    echo "Successfully compressed $SOURCE_DIR into $OUTPUT_FILE"
  else
    echo "Failed to compress $SOURCE_DIR"
    exit 1
  fi
else
  echo "Source directory $SOURCE_DIR does not exist"
  exit 1
fi