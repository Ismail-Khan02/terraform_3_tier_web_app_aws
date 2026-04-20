output "alb_dns_name" {
  description = "DNS name of the external Application Load Balancer"
  value       = module.load_balancing.external_alb_dns_name
}

output "internal_alb_dns_name" {
  description = "DNS name of the internal Application Load Balancer"
  value       = module.load_balancing.internal_alb_dns_name
}

output "db_endpoint" {
  description = "RDS instance endpoint"
  value       = module.database.db_endpoint
}
