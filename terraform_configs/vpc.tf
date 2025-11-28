# Creating VPC 
resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidrs[0]
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "main-vpc"
    Environment = var.environment
  }
}