resource "aws_instance" "web_server" {
  count                  = 2
  ami                    = var.ec2_ami
  instance_type          = "t2.micro"
  
  subnet_id              = count.index == 0 ? aws_subnet.public-subnet-1.id : aws_subnet.public-subnet-2.id
  
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name               = var.key_name
  user_data              = file("data.sh")

  tags = {
    Name        = "web-server-${count.index + 1}" # Names them web-server-1 and web-server-2
    Environment = var.environment
  }
}