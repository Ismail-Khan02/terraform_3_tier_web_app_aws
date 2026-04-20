variable "environment" {
  description = "Environment name"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "ec2_ami" {
  description = "AMI ID for EC2 instances. Defaults to latest Amazon Linux 2 if null."
  type        = string
  default     = null
}

variable "instance_type" {
  description = "EC2 instance type for web and app servers"
  type        = string
  default     = "t3.micro"
}

variable "web_sg_id" {
  description = "Security group ID for web servers"
  type        = string
}

variable "app_sg_id" {
  description = "Security group ID for app servers"
  type        = string
}

variable "instance_profile_name" {
  description = "IAM instance profile name"
  type        = string
}

variable "internal_alb_dns" {
  description = "DNS name of the internal ALB"
  type        = string
}

variable "db_address" {
  description = "RDS instance address"
  type        = string
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "web_subnet_ids" {
  description = "Subnet IDs for the web ASG"
  type        = list(string)
}

variable "application_subnet_ids" {
  description = "Subnet IDs for the app ASG"
  type        = list(string)
}

variable "external_alb_tg_arn" {
  description = "External ALB target group ARN"
  type        = string
}

variable "internal_alb_tg_arn" {
  description = "Internal ALB target group ARN"
  type        = string
}

variable "web_asg_min_size" {
  description = "Minimum size of the web ASG"
  type        = number
}

variable "web_asg_max_size" {
  description = "Maximum size of the web ASG"
  type        = number
}

variable "web_asg_desired_capacity" {
  description = "Desired capacity of the web ASG"
  type        = number
}

variable "app_asg_min_size" {
  description = "Minimum size of the app ASG"
  type        = number
}

variable "app_asg_max_size" {
  description = "Maximum size of the app ASG"
  type        = number
}

variable "app_asg_desired_capacity" {
  description = "Desired capacity of the app ASG"
  type        = number
}
