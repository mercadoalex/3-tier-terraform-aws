#### SG Application Load Balancer

resource "aws_security_group" "alb-security-group" {
  name        = "ALB Security group"
  description = "Allow HTTP and HTTPS access on port 80/443"
  vpc_id      = aws_vpc.vpc_alumno04.id

  ingress {
    description = "http access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "https access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # all
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "ALB Security group"
  }
}