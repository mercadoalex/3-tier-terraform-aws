resource "aws_launch_configuration" "auto-scaling-group-public" {
  name_prefix   = "auto-scaling-group"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  key_name      = var.key_pair_name

  security_groups = [aws_security_group.webserver-security-group.id]

  user_data = base64encode(templatefile("${path.root}/web-setup-test.sh", {
    file_content = "version 1.0 - auto-scaling"
  }))

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "auto-scaling-group-public" {
  desired_capacity   = 2
  max_size           = 5
  min_size           = 1

  launch_configuration = aws_launch_configuration.auto-scaling-group-public.id

  vpc_zone_identifier = [aws_subnet.public-web-subnet-1.id, aws_subnet.public-web-subnet-2.id]

  tag {
    key                 = "Name"
    value               = "${var.instance_name_prefix}-asg-public"
    propagate_at_launch = true
  }
}

######## ASG for Application Tier ########

resource "aws_launch_configuration" "auto-scaling-group-private" {
  name_prefix   = "auto-scaling-group-private"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  key_name      = var.key_pair_name

  security_groups = [aws_security_group.ssh-aws-security-group.id]

  user_data = base64encode(templatefile("${path.root}/web-setup-test.sh", {
    file_content = "version 1.0 - auto-scaling"
  }))

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "auto-scaling-group-private" {
  desired_capacity   = 2
  max_size           = 5
  min_size           = 1

  launch_configuration = aws_launch_configuration.auto-scaling-group-private.id

  vpc_zone_identifier = [aws_subnet.private-app-subnet-1.id, aws_subnet.private-app-subnet-2.id]

  tag {
    key                 = "Name"
    value               = "${var.instance_name_prefix}-asg-private"
    propagate_at_launch = true
  }
}