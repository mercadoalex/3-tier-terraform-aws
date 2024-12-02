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

##### RSA Key de 4096 bits #####
resource "tls_private_key" "rsa-4096-alumno04" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_file" "tf_key"{
  content =  tls_private_key.rsa-4096-alumno04.private_key_pem
  filename = var.file_name
}

##### key pair #####
resource "aws_key_pair" "tf_key" {
  key_name   = var.key_pair_name
  public_key = tls_private_key.rsa-4096-alumno04.public_key_openssh
}


##### Resource EC" Instance #####

resource "aws_instance" "PublicWebTemplate" {
  #count = length(var.instance_tag)
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public-web-subnet-1.id
  vpc_security_group_ids = [aws_security_group.webserver-security-group.id]
  key_name               = var.key_pair_name
  user_data              = file("install-apache.sh")
  tags = {
    Name = "${var.instance_name_prefix}-${count.index + 1}"
  }
    count = var.instance_count
}

resource "aws_instance" "private-app-template" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private-app-subnet-1.id
  vpc_security_group_ids = [aws_security_group.ssh-aws-security-group.id]
  tags = {
    Name = "app-asg"
  }
}

