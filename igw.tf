#####IGW
resource "aws_internet_gateway" "igw_alumno04" {
  vpc_id = aws_vpc.vpc_alumno04.id
  tags = {
    Name = "TEST igw"
  }
}