# Creating Route Table
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id

  route = {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name        = "main-rt"
    Environment = var.environment
  }
}

# Associating Route Table with Subnets
resource "aws_route_table_association" "rta1" {
  subnet_id      = var.public_subnet_ids[0]
  route_table_id = aws_route_table.rt.id
}

# Associating Route Table with 2nd Subnet
resource "aws_route_table_association" "rta2" {
  subnet_id      = var.public_subnet_ids[1]
  route_table_id = aws_route_table.rt.id
}  
