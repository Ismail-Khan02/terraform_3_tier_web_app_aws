# Creating EC2 Instance in Public Subnet
resource "aws_instance" "web_server" {
  ami                    = var.ec2_ami
  instance_type          = "t2.micro"
  count                  = 1     
  subnet_id              = var.public_subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name               = var.key_name

  tags = {
    Name        = "web-server"
    Environment = var.environment
  }
  
}

