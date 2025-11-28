resource "aws_security_group" "database_sg" { 
  name        = "database-sg"
  description = "Security group for database"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    # FIXED: Changed application_sg to web_sg
    security_groups = [aws_security_group.web_sg.id]
    description     = "Allow MySQL traffic from Web SG"
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