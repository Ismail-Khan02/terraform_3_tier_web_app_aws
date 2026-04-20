variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs for the external ALB"
  type        = list(string)
}

variable "application_subnet_ids" {
  description = "Application subnet IDs for the internal ALB"
  type        = list(string)
}

variable "alb_sg_id" {
  description = "Security group ID for the external ALB"
  type        = string
}

variable "internal_alb_sg_id" {
  description = "Security group ID for the internal ALB"
  type        = string
}
