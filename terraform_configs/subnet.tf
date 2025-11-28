# Creating 1st Web Subnet
resource "aws_subnet" "public-subnet-1" {
  vpc_id            = var.vpc_id
  cidr_block        = var.subnet_cidr
  availability_zone = var.availability_zones[0]
  map_customer_owned_ip_on_launch = true


  tags = {
    Name        = "public-subnet-1"
    Environment = var.environment
  }
} 

# Creating Application Subnet 1
resource "aws_subnet" "application-subnet-1" {
  vpc_id            = var.vpc_id
  cidr_block        = var.application_subnet_cidrs[0]
  map_customer_owned_ip_on_launch = true
  availability_zone = var.availability_zones[0]

  tags = {
    Name        = "application-subnet-1"
    Environment = var.environment
  }
  
}

# Creating Database Private Subnet 1
resource "aws_subnet" "database-subnet-1" {
  vpc_id            = var.vpc_id
  cidr_block        = var.database_subnet_cidrs[0]
  map_customer_owned_ip_on_launch = false
  availability_zone = var.availability_zones[0]

  tags = {
    Name        = "database-subnet-1"
    Environment = var.environment
  }
  
}


