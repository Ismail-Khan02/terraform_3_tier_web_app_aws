output "db_address" {
  value = aws_db_instance.this.address
}

output "db_endpoint" {
  value = aws_db_instance.this.endpoint
}
