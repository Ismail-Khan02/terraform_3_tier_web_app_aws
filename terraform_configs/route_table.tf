# --- PUBLIC ROUTING (Connects to Internet Gateway) ---
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "public-rt", Environment = var.environment }
}

resource "aws_route_table_association" "public_rta1" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.public_rt.id
}
resource "aws_route_table_association" "public_rta2" {
  subnet_id      = aws_subnet.public-subnet-2.id
  route_table_id = aws_route_table.public_rt.id
}

# --- PRIVATE ROUTING AZ 1 (Uses NAT 1) ---
resource "aws_route_table" "private_rt_1" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_1.id
  }
  tags = { Name = "private-rt-1", Environment = var.environment }
}

resource "aws_route_table_association" "app_rta1" {
  subnet_id      = aws_subnet.application-subnet-1.id
  route_table_id = aws_route_table.private_rt_1.id
}
resource "aws_route_table_association" "db_rta1" {
  subnet_id      = aws_subnet.database-subnet-1.id
  route_table_id = aws_route_table.private_rt_1.id
}

# --- PRIVATE ROUTING AZ 2 (Uses NAT 2) ---
resource "aws_route_table" "private_rt_2" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_2.id
  }
  tags = { Name = "private-rt-2", Environment = var.environment }
}

resource "aws_route_table_association" "app_rta2" {
  subnet_id      = aws_subnet.application-subnet-2.id
  route_table_id = aws_route_table.private_rt_2.id
}
resource "aws_route_table_association" "db_rta2" {
  subnet_id      = aws_subnet.database-subnet-2.id
  route_table_id = aws_route_table.private_rt_2.id
}