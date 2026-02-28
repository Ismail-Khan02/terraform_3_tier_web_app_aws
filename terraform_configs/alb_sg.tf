# Application Load Balancer Security Group
resource "aws_security_group" "alb-sg" {
  name        = "alb-sg"
  description = "Security group for Application Load Balancer"
  vpc_id      = aws_vpc.main.id

  # Ingress: Allow HTTP from the Internet
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP from Anywhere"
  }

  /* # Ingress: Allow HTTPS from the Internet 
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS from Anywhere"
  } */

  # Egress: Allow traffic TO the Web Servers
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "alb-sg"
    Environment = var.environment
  }
}

resource "aws_security_group" "internal-alb-sg" {
  name        = "internal-alb-sg"
  description = "Security group for Internal Application Load Balancer"
  vpc_id      = aws_vpc.main.id

  # Ingress: Allow HTTP from the VPC
  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    description     = "Allow HTTP from VPC"
    security_groups = [aws_security_group.web_sg.id] # Allow from Web SG
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    description     = "Allow HTTP from VPC"
    security_groups = [aws_security_group.web_sg.id] # Allow from Web SG
  }

  # Ingress: Allow HTTPS from the VPC 
  # ingress {
  #   from_port       = 443
  #   to_port         = 443
  #   protocol        = "tcp"
  #   cidr_blocks     = [aws_vpc.main.cidr_block]
  #   description     = "Allow HTTPS from VPC"
  #   security_groups = [aws_security_group.web_sg.id] # Allow from Web SG
  # }

  # Egress: Allow traffic TO the Web Servers
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

}