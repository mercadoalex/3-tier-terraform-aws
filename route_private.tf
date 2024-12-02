########Route table 

resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.vpc_alumno04.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_1.id
  }
  tags = {
    Name = " Private Route Table"

  }

}

######route Table Association
resource "aws_route_table_association" "nat_route_1" {
  subnet_id      = aws_subnet.private-app-subnet-1.id
  route_table_id = aws_route_table.private-route-table.id
}

resource "aws_route_table_association" "nat_route_2" {
  subnet_id      = aws_subnet.private-app-subnet-2.id
  route_table_id = aws_route_table.private-route-table.id
}

