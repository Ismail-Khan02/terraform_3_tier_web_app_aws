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
