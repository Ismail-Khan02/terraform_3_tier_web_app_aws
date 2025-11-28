# --- PUBLIC ROUTE TABLE (Connects to Internet Gateway) ---
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name        = "public-rt"
    Environment = var.environment
  }
}

# Associate Public Subnets with Public Route Table
resource "aws_route_table_association" "public_rta1" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_rta2" {
  subnet_id      = aws_subnet.public-subnet-2.id
  route_table_id = aws_route_table.public_rt.id
}


# --- PRIVATE ROUTE TABLE (Connects to NAT Gateway) ---
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name        = "private-rt"
    Environment = var.environment
  }
}

# Associate Application Subnet (Tier 2) with Private Route Table
resource "aws_route_table_association" "app_rta1" {
  subnet_id      = aws_subnet.application-subnet-1.id
  route_table_id = aws_route_table.private_rt.id
}

# Associate Database Subnets (Tier 3) with Private Route Table
resource "aws_route_table_association" "db_rta1" {
  subnet_id      = aws_subnet.database-subnet-1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "db_rta2" {
  subnet_id      = aws_subnet.database-subnet-2.id
  route_table_id = aws_route_table.private_rt.id
}