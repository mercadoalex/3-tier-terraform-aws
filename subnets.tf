######SUBNETS

resource "aws_subnet" "public-web-subnet-1" {
  vpc_id                  = aws_vpc.vpc_alumno04.id
  cidr_block              = var.public-web-subnet-1-cidr
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "Public subnet 1"
  }
}

###Public subnet 2
resource "aws_subnet" "public-web-subnet-2" {
  vpc_id                  = aws_vpc.vpc_alumno04.id
  cidr_block              = var.public-web-subnet-2-cidr
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "Public subnet 2"
  }
}
### Private subnet-app 1
resource "aws_subnet" "private-app-subnet-1" {
  vpc_id                  = aws_vpc.vpc_alumno04.id
  cidr_block              = var.private-app-subnet-1-cidr
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false
  tags = {
    Name = "Private subnet 1 - App Tier"
  }
}
### Private subnet-app 2
resource "aws_subnet" "private-app-subnet-2" {
  vpc_id                  = aws_vpc.vpc_alumno04.id
  cidr_block              = var.private-app-subnet-2-cidr
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = false
  tags = {
    Name = "Private subnet 2 - App Tier"
  }
}

####Private subnet-db 1 
resource "aws_subnet" "private-db-subnet-1" {
  vpc_id                  = aws_vpc.vpc_alumno04.id
  cidr_block              = var.private-db-subnet-1-cidr
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false
  tags = {
    Name = "Private subnet 1  - DB Tier"
  }
}

####Private subnet-db 2

resource "aws_subnet" "private-db-subnet-2" {
  vpc_id                  = aws_vpc.vpc_alumno04.id
  cidr_block              = var.private-db-subnet-2-cidr
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = false
  tags = {
    Name = "Private subnet 2 - DB Tier"
  }
}

