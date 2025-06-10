output "app_tg_arn" {
  value = aws_lb_target_group.app_tg.arn
}
output "metabase_tg_arn" {
  value = aws_lb_target_group.metabase_tg.arn
}

