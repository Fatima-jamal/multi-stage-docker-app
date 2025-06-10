variable "vpc_id" {
  description = "VPC ID where RDS security groups will be created"
  type        = string
}

variable "allowed_sg_ids" {
  description = "List of SGs allowed to access PostgreSQL and MySQL"
  type        = list(string)
}

variable "private_subnet_a_id" {
  description = "Private subnet A for DB subnet group (if needed)"
  type        = string
}

variable "private_subnet_b_id" {
  description = "Private subnet B for DB subnet group (if needed)"
  type        = string
}
