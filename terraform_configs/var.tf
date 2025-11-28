# Variables for the 3-Tier Web Application Infrastructure on AWS

variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"] 
}

variable "environment" {
  description = "The environment for the resources"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# --- Subnet Configuration ---
variable "public_subnet_cidrs" {
  description = "CIDR blocks for Public Web Subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "application_subnet_cidrs" {
  description = "CIDR blocks for Application Subnets"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "database_subnet_cidrs" {
  description = "CIDR blocks for Database Subnets"
  type        = list(string)
  default     = ["10.0.21.0/24", "10.0.22.0/24"]
}

# --- Instance Configuration ---

variable "ec2_ami" {
  description = "The AMI ID for the EC2 instance"
  type        = string
  default     = "ami-0c02fb55956c7d316"
}

variable "key_name" {
  description = "The name of the key pair"
  type        = string
  default     = "my-key-pair"
}

variable "db_password" {
  description = "Password for the RDS instance"
  type        = string
  sensitive   = true

}

# --- Database Configuration ---

# Database username
variable "db_username" {
  description = "Username for the RDS instance"
  type        = string
  default     = "admin"
}