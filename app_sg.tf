######### SG Application Tier (Bastion host) #########

resource "aws_security_group" "ssh-aws-security-group" {
  name        = "SSH Acess"
  description = "Enable ssh access on port 22c"
  vpc_id      = aws_vpc.vpc_alumno04.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.ssh-locate}"]
  }

  egress {

    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SSH sevurity group"
  }
}
