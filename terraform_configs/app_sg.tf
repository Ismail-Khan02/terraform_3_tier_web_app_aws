# Application Server Security Group
resource "aws_security_group" "app_sg" {
  name        = "app-sg"
  description = "Security group for Application Server"
  vpc_id      = aws_vpc.main.id

  # Ingress: Allow traffic ONLY from Web SG (e.g., on port 3000)
  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
    description     = "Allow traffic from Web Layer"
  }

  # Egress: Allow traffic to Database SG (MySQL port)
  egress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    # We will reference the DB SG by ID later, or use CIDR if circular dependency occurs
    # Ideally, specify the destination SG here if possible, or allow outbound generally:
    cidr_blocks     = ["0.0.0.0/0"] 
  }
  
  # Egress: Allow internet access for updates (via NAT Gateway - note: you need a NAT Gateway for this to work in a private subnet!)
  # If you don't have a NAT Gateway, this instance cannot download Node.js.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "app-sg"
    Environment = var.environment
  }
}