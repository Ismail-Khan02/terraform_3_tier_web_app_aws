# Creating Database Security Group
resource "aws_security_group" "database_sg" { 
  name        = "database-sg"
  description = "Security group for database"
  vpc_id      = var.vpc_id

  # Ingress rule to allow traffic from application security group
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.web_sg]
    description = "Allow PostgreSQL traffic from application SG"
  }

  # Egress rule to allow all outbound traffic
  egress {
    from_port   = 32768
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }
    tags = {
        Name        = "database-sg"
        Environment = var.environment
    }
}   

