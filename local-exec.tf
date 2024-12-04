resource "null_resource" "check_key_file" {
  provisioner "local-exec" {
    command = <<EOT
      if [ ! -f ${var.public_key_file} ]; then
        ssh-keygen -t rsa -b 2048 -f ${var.private_key_file} -q -N ""
        mv ${var.private_key_file}.pub ${var.public_key_file}
      fi
    EOT
  }
}
