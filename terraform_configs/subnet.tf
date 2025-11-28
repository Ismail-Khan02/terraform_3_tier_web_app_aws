# Creating 1st Web Subnet (Public)
resource "aws_subnet" "public-subnet-1" {
  vpc_id                  = aws_vpc.main.id  
  cidr_block              = var.public_subnet_cidrs[0]
  availability_zone       = var.availability_zones[0]
  
  map_public_ip_on_launch = true 

  tags = {
    Name        = "public-subnet-1"
    Environment = var.environment
  }
}

resource "aws_subnet" "public-subnet-2" {
  vpc_id                  = aws_vpc.main.id  
  cidr_block              = var.public_subnet_cidrs[1]
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = true 

  tags = {
    Name        = "public-subnet-2"
    Environment = var.environment
  }
}

# Creating Application Subnet 1 (Private)
resource "aws_subnet" "application-subnet-1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.application_subnet_cidrs[0]
  availability_zone       = var.availability_zones[0]
  
  map_public_ip_on_launch = false 

  tags = {
    Name        = "application-subnet-1"
    Environment = var.environment
  }
}

# Creating Application Subnet 2 (Private)
resource "aws_subnet" "application-subnet-2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.application_subnet_cidrs[1]
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = false

  tags = {
    Name        = "application-subnet-2"
    Environment = var.environment
  }
}


# Creating Database Private Subnet 1 (Private)
resource "aws_subnet" "database-subnet-1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.database_subnet_cidrs[0]
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = false

  tags = {
    Name        = "database-subnet-1"
    Environment = var.environment
  }
}
# Creating Database Private Subnet 2 (Private)
resource "aws_subnet" "database-subnet-2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.database_subnet_cidrs[1]
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = false

  tags = {
    Name        = "database-subnet-2"
    Environment = var.environment
  }
}

resource "aws_db_subnet_group" "mydb-subnet-group" {
  name       = "mydb-subnet-group"
  subnet_ids = [aws_subnet.database-subnet-1.id, aws_subnet.database-subnet-2.id]

  tags = {
    Name        = "mydb-subnet-group"
    Environment = var.environment
  }
}