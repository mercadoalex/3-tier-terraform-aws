resource "null_resource" "check_orcreate_key_file" {
  provisioner "local-exec" {
    command = <<EOT
      # Create the directory for the public key file if it doesn't exist
      echo "Creating directory for the public key file if it doesn't exist..."
      # Create the directory path for the public key file
      mkdir -p $(dirname ${var.public_key_file})

      # Check if the public key file exists
      if [ ! -f ${var.public_key_file} ]; then
        echo "Public key file does not exist. Generating a new RSA key pair..."

        # Generate a new RSA key pair with 2048 bits
        ssh-keygen -t rsa -b 2048 -f ${var.private_key_file} -q -N ""
        echo "RSA key pair generated."

        # Move the generated public key to the specified public key file
        mv ${var.private_key_file}.pub ${var.public_key_file}
        echo "Public key moved to ${var.public_key_file}."
      else
        echo "Public key file already exists at ${var.public_key_file}."
      fi
    EOT
  }
}

resource "null_resource" "read_public_key" {
  depends_on = [null_resource.check_orcreate_key_file]
  provisioner "local-exec" {
    command = <<EOT
      # Read the content of the public key file and store it in an environment variable
      echo "Reading the content of the public key file..."
      PUBLIC_KEY_CONTENT=$(cat ${var.public_key_file})
      echo "Public key content: $PUBLIC_KEY_CONTENT"
    EOT
  }
}
