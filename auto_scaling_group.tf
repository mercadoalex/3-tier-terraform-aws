#######ASG for Presentation Tier ######

resource "aws_launch_template" "auto-scaling-group" {
  name_prefix   = "auto-scaling-group"
  image_id      = data.aws_ami.amazon_linux_2.id
  instance_type = "t2.micro"
  key_name      = var.key_pair_name
  network_interfaces {
    subnet_id       = aws_subnet.public-web-subnet-1.id
    security_groups = [aws_security_group.webserver-security-group.id]
    associate_public_ip_address = true
  }
  tags = {
    Name = "${var.instance_name_prefix}-asg"
  }
}

resource "aws_autoscaling_group" "asg-1" {
  availability_zones = ["us-east-1a"]
  desired_capacity   = 1
  max_size           = 3
  min_size           = 1

  launch_template {
    id      = aws_launch_template.auto-scaling-group.id
    version = "$Latest"
  }
}


########ASG for Applciation Tier

resource "aws_launch_template" "auto-scaling-group-private" {
  name_prefix   = "auto-scaling-group-private"
  image_id      = data.aws_ami.amazon_linux_2.id
  instance_type = "t2.micro"
  key_name      = var.key_pair_name
  network_interfaces {
    subnet_id       = aws_subnet.private-app-subnet-1.id
    security_groups = [aws_security_group.ssh-aws-security-group.id]
  }
}

resource "aws_autoscaling_group" "asg-2" {
  availability_zones = ["us-east-1a"]
  desired_capacity   = 1
  max_size           = 2
  min_size           = 1

  launch_template {
    id      = aws_launch_template.auto-scaling-group-private.id
    version = "$Latest"
  }
}