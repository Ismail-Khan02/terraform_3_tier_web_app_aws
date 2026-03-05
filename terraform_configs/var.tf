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

variable "web_subnet_ciders" {
  description = "CIDR blocks for Web Subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "application_subnet_ciders" {
  description = "CIDR blocks for Application Subnets"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

# Auto Scaling Configuration
variable "web_asg_desired_capacity" {
  description = "Desired capacity for the web tier Auto Scaling Group"
  type        = number
  default     = 2
}

variable "web_asg_min_size" { 
  description = "Minimum size for the web tier Auto Scaling Group"
  type        = number
  default     = 2
  
}

variable "web_asg_max_size" { 
  description = "Maximum size for the web tier Auto Scaling Group"
  type        = number
  default     = 4
  
}

variable "app_asg_desired_capacity" {
  description = "Desired capacity for the app tier Auto Scaling Group"
  type        = number
  default     = 2
}

variable "app_asg_min_size" {
  description = "Minimum size for the app tier Auto Scaling Group"
  type        = number
  default     = 2
}

variable "app_asg_max_size" {
  description = "Maximum size for the app tier Auto Scaling Group"
  type        = number
  default     = 4
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
  default     = null 
}

# --- Database Configuration ---

# Database username
variable "db_username" {
  description = "Username for the RDS instance"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Password for the RDS instance"
  type        = string
  sensitive   = true

}

variable "db_name" {
  description = "Database name for the RDS instance"
  type        = string
  default     = "mydb"

}

variable "alert_email" {
  description = "Email address for CloudWatch alarms"
  type        = string
  
}