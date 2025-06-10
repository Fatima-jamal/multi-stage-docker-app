variable "domain_name" {
  type = string
}

variable "alb_dns_name" {
  type = string
}

variable "alb_zone_id" {
  type = string
}

variable "hosted_zone_id" {
  description = "The ID of the existing Route 53 hosted zone"
  type        = string
}


