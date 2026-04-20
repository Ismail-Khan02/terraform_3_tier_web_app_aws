variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public (ALB) subnets"
  type        = list(string)
}

variable "web_subnet_cidrs" {
  description = "CIDR blocks for private web tier subnets"
  type        = list(string)
}

variable "application_subnet_cidrs" {
  description = "CIDR blocks for private application tier subnets"
  type        = list(string)
}
