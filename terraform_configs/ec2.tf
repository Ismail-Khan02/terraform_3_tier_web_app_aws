resource "aws_instance" "web_server" {
  ami                    = var.ec2_ami
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public-subnet-1.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name               = var.key_name
  
  # FIXED: Added User Data to install Apache
  user_data              = file("data.sh")

  tags = {
    Name        = "web-server"
    Environment = var.environment
  }
}