# Define Security Group for Database Layer
resource "aws_security_group" "database_sg" { 
  name        = "database-sg"
  description = "Security group for database"
  vpc_id      = aws_vpc.main.id

ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id] 
    description     = "Allow MySQL traffic from App SG"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name        = "database-sg"
    Environment = var.environment
  }
}