variable "environment" {
  description = "Environment name"
  type        = string
}

variable "external_alb_arn" {
  description = "ARN of the external ALB to associate the WAF with"
  type        = string
}
