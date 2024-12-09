#######ASG for Presentation Tier ######
resource "aws_launch_template" "auto-scaling-group-public" {
  #count         = var.instance_count_autoscaling
  name_prefix   = "auto-scaling-group-public"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  key_name      = var.key_pair_name
  network_interfaces {
    subnet_id                   = aws_subnet.public-web-subnet-1.id
    security_groups             = [aws_security_group.webserver-security-group.id]
    associate_public_ip_address = true
  }
  user_data = base64encode(templatefile("${path.root}/web-setup.sh", {
    #file_content = "version 1.0 - #${count.index}"
    file_content = "version 1.0 - auto-scaling"
  }))
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.instance_name_prefix}-asg"
    }
  }
  tag_specifications {
    resource_type = "volume"
    tags = {
      Name = "${var.instance_name_prefix}-asg"
    }
  }
}
resource "aws_autoscaling_group" "auto-scaling-group-public" {
  desired_capacity = 2
  max_size         = 5
  min_size         = 1

  launch_template {
    id = aws_launch_template.auto-scaling-group-public.id
    #id      = aws_launch_template.auto-scaling-group-public.id[count.index]
    version = "$Latest"
  }

  vpc_zone_identifier = [aws_subnet.public-web-subnet-1.id, aws_subnet.public-web-subnet-2.id]

  tag {
    key                 = "Name"
    value               = "${var.instance_name_prefix}-asg-public"
    propagate_at_launch = true
  }
}

######## ASG for Application Tier ########
resource "aws_launch_template" "auto-scaling-group-private" {
  #count         = var.instance_count_autoscaling
  name_prefix   = "auto-scaling-group-private"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  key_name      = var.key_pair_name
  network_interfaces {
    subnet_id                   = aws_subnet.private-app-subnet-1.id
    security_groups             = [aws_security_group.ssh-aws-security-group.id]
    associate_public_ip_address = true
  }
  user_data = base64encode(templatefile("${path.root}/web-setup.sh", {
    #file_content = "version 1.0 - #${count.index}"
    file_content = "version 1.0 - auto-scaling"
  }))
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.instance_name_prefix}-asg"
    }
  }
  tag_specifications {
    resource_type = "volume"
    tags = {
      Name = "${var.instance_name_prefix}-asg"
    }
  }
}

resource "aws_autoscaling_group" "auto-scaling-group-private" {
  desired_capacity = 2
  max_size         = 5
  min_size         = 1
  #id = aws_launch_template.auto-scaling-group-private.id
  vpc_zone_identifier = [aws_subnet.private-app-subnet-1.id, aws_subnet.private-app-subnet-2.id]

  tag {
    key                 = "Name"
    value               = "${var.instance_name_prefix}-asg-private"
    propagate_at_launch = true
  }
  launch_template {
    id = aws_launch_template.auto-scaling-group-private.id
    #id      = aws_launch_template.auto-scaling-group-public.id[count.index]
    version = "$Latest"
  }
}