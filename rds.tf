##### database subnet group ####

resource "aws_db_subnet_group" "database-subnet-group2" {
  name       = "database subnets"
  subnet_ids = ["${aws_subnet.private-db-subnet-1.id}", "${aws_subnet.private-db-subnet-2.id}"]

  tags = {
    Name = "Database Subnets"
  }
}

##### database instance ####

resource "aws_db_instance" "database-instance" {
  allocated_storage      = 10
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t3.micro"
  db_name                = "sqldb"
  username               = "Admin2024"
  password               = "Admin2024#"
  parameter_group_name   = "default.mysql5.7"
  skip_final_snapshot    = true
  availability_zone      = "us-east-1b"
  db_subnet_group_name   = aws_db_subnet_group.database-subnet-group.name
  multi_az               = var.multi-az-deployment
  vpc_security_group_ids = ["${aws_security_group.database_security_group.id}"]
}

