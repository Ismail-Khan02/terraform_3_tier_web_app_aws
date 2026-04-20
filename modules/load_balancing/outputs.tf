output "external_alb_arn" {
  value = aws_lb.external.arn
}

output "external_alb_dns_name" {
  value = aws_lb.external.dns_name
}

output "external_alb_arn_suffix" {
  value = aws_lb.external.arn_suffix
}

output "internal_alb_dns_name" {
  value = aws_lb.internal.dns_name
}

output "external_alb_tg_arn" {
  value = aws_lb_target_group.external.arn
}

output "internal_alb_tg_arn" {
  value = aws_lb_target_group.internal.arn
}
