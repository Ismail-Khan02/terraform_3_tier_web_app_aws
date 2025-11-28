# Creating RDS Instance
resource "aws_db_instance" "mydb" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t2.micro"
  db_name              = "mydb"
  username             = var.db_username
  password             = var.db_password 
  multi_az             = true
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_security_group.database_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.mydb-subnet-group.name

  tags = {
    Name        = "my-rds-instance"
    Environment = var.environment
  }
}