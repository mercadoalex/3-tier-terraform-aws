##### Data Source #####

data "aws_ami" "amazon_linux" {
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

resource "aws_instance" "blue-web" {
  count         = var.enable_blue_env ? var.blue_instance_count : 0
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  #subnet_id              = module.vpc.private_subnets[count.index % length(module.vpc.private_subnets)]
  #Use the element function to select a subnet ID from a list of subnets based on the instance index.
  subnet_id = element([aws_subnet.public-web-subnet-1.id, aws_subnet.public-web-subnet-2.id], count.index % 2)
  #vpc_security_group_ids = [module.app_security_group.security_group_id]
  vpc_security_group_ids = [aws_security_group.webserver-security-group.id]
  user_data = templatefile("${path.root}/web-setup-test.sh", {
    file_content = "version 1.0 - #${count.index}"
  })

  tags = {
    Name = "blue-${count.index}"
  }
}

resource "aws_lb_target_group" "blue_http" {
  #name    = "blue-tg-${random_pet.app.id}-lb"
  name     = "blue-tg-${random_pet.app.id}-http-lb"
  port     = 80
  protocol = "HTTP"
  #vpc_id   = module.vpc.vpc_id
  vpc_id = aws_vpc.vpc_alumno04.id
  health_check {
    port     = 80
    protocol = "HTTP"
    timeout  = 5
    interval = 10
  }
}
/*
resource "aws_lb_target_group" "blue_https" {
  name     = "blue-tg-${random_pet.app.id}-https-lb"
  port     = 443
  protocol = "HTTPS"
  vpc_id   = aws_vpc.vpc_alumno04.id

  health_check {
    port     = 443
    protocol = "HTTPS"
    timeout  = 5
    interval = 10
  }
}
*/
resource "aws_lb_target_group_attachment" "blue_http" {
  count            = length(aws_instance.blue-web)
  target_group_arn = aws_lb_target_group.blue_http.arn
  target_id        = aws_instance.blue-web[count.index].id
  port             = 80
}

/*
resource "aws_lb_target_group_attachment" "blue_https" {
  count            = length(aws_instance.blue-web)
  target_group_arn = aws_lb_target_group.blue_https.arn
  target_id        = aws_instance.blue-web[count.index].id
  port             = 443
}
*/