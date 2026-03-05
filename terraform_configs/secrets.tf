resource "aws_secretsmanager_secret" "db_password" {
  name        = "db_password"
  description = "Password for the RDS database instance"

  tags = {
    Name        = "db-password-secret"
    Environment = var.environment
  }
  
}

resource "aws_secretsmanager_secret_version" "db_password_version" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = jsonencode({
    username = var.db_username
    password = var.db_password
  })
}

