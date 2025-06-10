output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "app_sg_id" {
  value = aws_security_group.app_sg.id
}

output "postgres_sg_id" {
  value = aws_security_group.postgres_sg.id
}

output "mysql_sg_id" {
  value = aws_security_group.mysql_sg.id
}
