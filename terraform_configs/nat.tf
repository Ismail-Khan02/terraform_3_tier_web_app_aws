# 1. Allocate an Elastic IP for the NAT Gateway
resource "aws_eip" "nat_eip" {
  domain = "vpc"   

  tags = {
    Name        = "nat-eip"
    Environment = var.environment
  }
}

# 2. Create the NAT Gateway in Public Subnet 1
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public-subnet-1.id

  tags = {
    Name        = "main-nat-gateway"
    Environment = var.environment
  }

# Ensure the Internet Gateway exists first
  depends_on = [aws_internet_gateway.igw]
}