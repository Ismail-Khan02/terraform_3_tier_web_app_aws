# Creating RDS Instance
resource "aws_db_instance" "mydb" {
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "8.0.44"
  instance_class         = "db.t3.micro"
  db_name                = "mydb"
  username               = var.db_username
  password               = var.db_password
  multi_az               = true
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.database_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.mydb-subnet-group.name

  tags = {
    Name        = "my-rds-instance"
    Environment = var.environment
  }
}

# Creating DB Subnet Group
/* resource "aws_db_subnet_group" "mydb-subnet-group" {
  name       = "mydb-subnet-group"
  subnet_ids = [aws_subnet.database-subnet-1.id, aws_subnet.database-subnet-2.id]

  tags = {
    Name        = "mydb-subnet-group"
    Environment = var.environment
  }
} */

/* resource "aws_security_group" "db-sg" {
  name        = "db-sg"
  description = "Security group for RDS instance"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }

} */