output "rds_endpoint" {
  value = aws_db_instance.postgres.endpoint
}

output "rds_identifier" {
  value = aws_db_instance.postgres.id
}
