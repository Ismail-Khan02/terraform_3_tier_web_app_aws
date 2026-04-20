resource "aws_secretsmanager_secret" "db_credentials" {
  name        = "${var.environment}/db_credentials"
  description = "RDS credentials for the ${var.environment} environment"

  tags = {
    Name        = "db-credentials-secret"
    Environment = var.environment
  }
}

resource "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = var.db_username
    password = var.db_password
  })
}

resource "aws_db_instance" "this" {
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "8.0.44"
  instance_class         = "db.t3.micro"
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  multi_az               = true
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true
  vpc_security_group_ids = [var.database_sg_id]
  db_subnet_group_name   = var.db_subnet_group_name

  tags = {
    Name        = "${var.environment}-rds-instance"
    Environment = var.environment
  }
}
