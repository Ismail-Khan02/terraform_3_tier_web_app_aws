variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public (ALB) subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "web_subnet_cidrs" {
  description = "CIDR blocks for private web tier subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "application_subnet_cidrs" {
  description = "CIDR blocks for private application tier subnets"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "ec2_ami" {
  description = "AMI ID for EC2 instances"
  type        = string
  default     = "ami-0c02fb55956c7d316"
}

variable "web_asg_desired_capacity" {
  description = "Desired capacity for the web tier ASG"
  type        = number
  default     = 2
}

variable "web_asg_min_size" {
  description = "Minimum size for the web tier ASG"
  type        = number
  default     = 2
}

variable "web_asg_max_size" {
  description = "Maximum size for the web tier ASG"
  type        = number
  default     = 4
}

variable "app_asg_desired_capacity" {
  description = "Desired capacity for the app tier ASG"
  type        = number
  default     = 2
}

variable "app_asg_min_size" {
  description = "Minimum size for the app tier ASG"
  type        = number
  default     = 2
}

variable "app_asg_max_size" {
  description = "Maximum size for the app tier ASG"
  type        = number
  default     = 4
}

variable "db_username" {
  description = "RDS master username"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "RDS master password"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "mydb"
}

variable "alert_email" {
  description = "Email address for CloudWatch alarm notifications"
  type        = string
}
