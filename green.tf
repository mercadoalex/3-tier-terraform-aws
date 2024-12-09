resource "aws_instance" "green" {
  count = var.enable_green_env ? var.green_instance_count : 0
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.micro"
 #subnet_id              = module.vpc.private_subnets[count.index % length(module.vpc.private_subnets)]
  subnet_id = element([aws_subnet.public-web-subnet-1.id, aws_subnet.public-web-subnet-2.id], count.index % 2)
  #vpc_security_group_ids = [module.app_security_group.security_group_id]
  vpc_security_group_ids = [aws_security_group.webserver-security-group.id]
  user_data = templatefile("${path.root}/web-setup-test.sh", {
    file_content = "version 1.0 - #${count.index}"
  })


  tags = {
    Name = "green-${count.index}"
  }
}

resource "aws_lb_target_group" "green-http" {
  name     = "green-tg-${random_pet.app.id}-lb"
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

resource "aws_lb_target_group_attachment" "green" {
  count            = length(aws_instance.green)
  target_group_arn = aws_lb_target_group.green-http.arn
  target_id        = aws_instance.green[count.index].id
  port             = 80
}
