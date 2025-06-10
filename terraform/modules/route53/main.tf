data "aws_route53_zone" "primary" {
  zone_id = var.hosted_zone_id
}


resource "aws_route53_record" "metabase" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "metabase.${var.domain_name}"
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}
