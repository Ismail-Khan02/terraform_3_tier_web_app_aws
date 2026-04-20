output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "web_subnet_ids" {
  value = aws_subnet.web[*].id
}

output "application_subnet_ids" {
  value = aws_subnet.application[*].id
}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.this.name
}
