# Application Server EC2 Instance
resource "aws_instance" "app_server" {
  ami                    = var.ec2_ami
  instance_type          = "t2.micro"
  
  # PLACEMENT: Put this in the Application Subnet (Private)
  subnet_id              = aws_subnet.application-subnet-1.id
  
  # SECURITY: Use the App Security Group
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  key_name               = var.key_name

  # SCRIPT: Run the Node.js install script
  user_data              = file("app_data.sh")

  tags = {
    Name        = "app-server"
    Environment = var.environment
  }
}