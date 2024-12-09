#### Web app load balancer ######

resource "aws_lb" "application-load-balancer" {
  name               = "web-external-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-security-group.id]
  subnets            = [aws_subnet.public-web-subnet-1.id, aws_subnet.public-web-subnet-2.id]

  enable_deletion_protection = false
  #enable_http2               = true
  #idle_timeout               = 60
  #enable_cross_zone_load_balancing = true

  tags = {
    Name = "App load balancer"
  }
}

resource "aws_lb_target_group" "alb-target-group" {
  name     = "appbalancertgp"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc_alumno04.id
  health_check {
    interval            = 30
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
  tags = {
    Name = "appbalancertgp"
  }
}

resource "aws_lb_target_group_attachment" "web-attachment" {
  count            = var.instance_count_autoscaling
  target_group_arn = aws_lb_target_group.alb-target-group.arn
  target_id        = aws_instance.PublicWebTemplate[count.index].id
  port             = 80
}

##create a listener on port 80 with redirect action 
resource "aws_lb_listener" "alb_http_listener" {
  load_balancer_arn = aws_lb.application-load-balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    #type = "redirect"
    type = "forward"
    #target_group_arn = aws_lb_target_group.blue.arn
    forward {
      target_group {
        arn    = aws_lb_target_group.blue_http.arn
        weight = lookup(local.traffic_dist_map[var.traffic_distribution], "blue", 100)
      }

      target_group {
        arn    = aws_lb_target_group.green-http.arn
        weight = lookup(local.traffic_dist_map[var.traffic_distribution], "green", 0)
      }

      stickiness {
        enabled  = false
        duration = 1
      }
    }
    # redirect {
    #  port        = "443"
    #  protocol    = "HTTPS"
    #  status_code = "HTTP_301"
    #}
  }
}
