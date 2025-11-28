resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr # Defined in the corrected var.tf I gave you
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "main-vpc"
    Environment = var.environment
  }
}