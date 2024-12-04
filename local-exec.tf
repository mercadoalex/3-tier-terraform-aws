resource "null_resource" "check_key_file" {
  provisioner "local-exec" {
    command = <<EOT
      # Create the directory for the public key file if it doesn't exist
      mkdir -p $(dirname ${var.public_key_file})

      # Check if the public key file exists
      if [ ! -f ${var.public_key_file} ]; then
        # Generate a new RSA key pair with 2048 bits
        ssh-keygen -t rsa -b 2048 -f ${var.private_key_file} -q -N ""

        # Move the generated public key to the specified public key file
        mv ${var.private_key_file}.pub ${var.public_key_file}
      fi
    EOT
  }
}
