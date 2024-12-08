##### Data Source #####

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }
}
/*
##### RSA Key de 4096 bits #####
resource "tls_private_key" "rsa-4096-alumno04" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_file" "private_key"{
  content =  tls_private_key.rsa-4096-alumno04.private_key_pem
  filename = var.private_key_file
}

##### Read Public Key File #####
resource "local_file" "public_key" {
  depends_on = [null_resource.check_key_file]
  filename   = var.public_key_file
  content    = file(var.public_key_file)
}
*/

##### Key Pair used to SSH into EC2 #####
resource "aws_key_pair" "tf_key" {
  //ensures that the key file is created before the key pair is created
  depends_on = [null_resource.read_public_key]
  key_name   = var.key_pair_name #name of the key pair
  #The file function reads the contents of the file and uses it as the public key material for the key pair.
  public_key = file(var.public_key_file)
  lifecycle {
    ignore_changes = [key_name]
  }
}

##### Resource EC2 Instance #####
resource "aws_instance" "PublicWebTemplate" {
  count                  = var.instance_count_bootstrap
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public-web-subnet-1.id
  vpc_security_group_ids = [aws_security_group.webserver-security-group.id]
  key_name               = var.key_pair_name
  #user_data                   = file("web-setup.sh")
  user_data = base64encode(templatefile("${path.root}/web-setup-test.sh", {
    file_content = "version 1.0 - #${count.index}"
  }))

  associate_public_ip_address = true

  tags = {
    Name = "${var.instance_name_prefix}-${count.index + 1}"
  }
}

resource "aws_instance" "private-app-template" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private-app-subnet-1.id
  vpc_security_group_ids = [aws_security_group.ssh-aws-security-group.id]
  user_data              = file("web-setup-test.sh")
  tags = {
    Name = "app-asg"
  }
}

