variable "environment" {
  description = "Environment name"
  type        = string
}

variable "db_username" {
  description = "RDS master username"
  type        = string
}

variable "db_password" {
  description = "RDS master password"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "database_sg_id" {
  description = "Security group ID for the database"
  type        = string
}

variable "db_subnet_group_name" {
  description = "DB subnet group name"
  type        = string
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot when destroying the RDS instance. Set to true for dev, false for prod."
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "Number of days to retain automated RDS backups (0 disables backups)"
  type        = number
  default     = 7
}
