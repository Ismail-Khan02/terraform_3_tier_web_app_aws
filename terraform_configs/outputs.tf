# Getting the DNS load balancer name
output "alb_dns_name" {
    value = aws_lb.external-alb.dns_name
}

