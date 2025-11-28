# --- NAT Gateway for Availability Zone 1 ---
resource "aws_eip" "nat_eip_1" {
  domain = "vpc"
  tags = {
    Name        = "nat-eip-1"
    Environment = var.environment
  }
}

resource "aws_nat_gateway" "nat_1" {
  allocation_id = aws_eip.nat_eip_1.id
  subnet_id     = aws_subnet.public-subnet-1.id

  tags = {
    Name        = "nat-gateway-1"
    Environment = var.environment
  }
  depends_on = [aws_internet_gateway.igw]
}

# --- NAT Gateway for Availability Zone 2 ---
resource "aws_eip" "nat_eip_2" {
  domain = "vpc"
  tags = {
    Name        = "nat-eip-2"
    Environment = var.environment
  }
}

resource "aws_nat_gateway" "nat_2" {
  allocation_id = aws_eip.nat_eip_2.id
  subnet_id     = aws_subnet.public-subnet-2.id

  tags = {
    Name        = "nat-gateway-2"
    Environment = var.environment
  }
  depends_on = [aws_internet_gateway.igw]
}