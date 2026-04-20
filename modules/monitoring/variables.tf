variable "environment" {
  description = "Environment name"
  type        = string
}

variable "alert_email" {
  description = "Email address for CloudWatch alarm notifications"
  type        = string
}

variable "web_asg_name" {
  description = "Name of the web tier Auto Scaling Group"
  type        = string
}

variable "app_asg_name" {
  description = "Name of the app tier Auto Scaling Group"
  type        = string
}

variable "external_alb_arn_suffix" {
  description = "ARN suffix of the external ALB (used for CloudWatch dashboard metrics)"
  type        = string
}

variable "db_instance_identifier" {
  description = "RDS instance identifier (used for CloudWatch dashboard metrics)"
  type        = string
}
