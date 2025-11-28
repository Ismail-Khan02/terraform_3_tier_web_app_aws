resource "aws_instance" "app_server" {
  count                  = 2
  ami                    = var.ec2_ami
  instance_type          = "t2.micro"
  
  # Logic: Distribute across App Subnet 1 and App Subnet 2
  subnet_id              = count.index == 0 ? aws_subnet.application-subnet-1.id : aws_subnet.application-subnet-2.id
  
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  key_name               = var.key_name

  # SCRIPT: Run the Node.js install script
  user_data              = file("app_data.sh")

  tags = {
    Name        = "app-server-${count.index + 1}"
    Environment = var.environment
  }
}