resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name        = "main-rt"
    Environment = var.environment
  }
}

resource "aws_route_table_association" "rta1" {
  # FIXED: Added .id
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_route_table_association" "rta2" {
  # FIXED: Added .id
  subnet_id      = aws_subnet.public-subnet-2.id
  route_table_id = aws_route_table.rt.id
}