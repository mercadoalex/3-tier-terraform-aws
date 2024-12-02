######VPC

resource "aws_vpc" "vpc_alumno04" {
  cidr_block         = var.vpc_cidr
  instance_tenancy   = "default"
  enable_dns_support = true

  tags = {
    Name = "central-network"
  }

}

