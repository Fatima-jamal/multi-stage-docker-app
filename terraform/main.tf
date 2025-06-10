provider "aws" {
  region = "us-west-1"
}

module "vpc" {
  source = "./modules/vpc"
}

module "security_groups" {
  source = "./modules/security_groups"
  vpc_id = module.vpc.vpc_id
}

module "alb" {
  source            = "./modules/alb"
  vpc_id            = module.vpc.vpc_id
  subnet_ids        = module.vpc.public_subnet_ids
  alb_sg_id         = module.security_groups.alb_sg_id
  target_sg_id      = module.security_groups.app_sg_id
  target_port       = 8080
}

module "rds" {
  source              = "./modules/rds"
  vpc_id              = module.vpc.vpc_id
  private_subnet_a_id = module.vpc.private_subnet_a_id
  private_subnet_b_id = module.vpc.private_subnet_b_id
  db_username         = var.db_username
  db_password         = var.db_password
  postgres_sg_id      = module.security_groups.postgres_sg_id
  mysql_sg_id         = module.security_groups.mysql_sg_id
}

module "ec2" {
  source             = "./modules/ec2"
  ami_id             = var.ami_id
  instance_type      = var.instance_type
  public_subnet_ids  = module.vpc.public_subnet_ids
  sg_id              = module.security_groups.app_sg_id
  target_group_arn   = module.alb.app_tg_arn
  project_name       = var.project_name
  user_data_script   = var.user_data_script
}

module "route53" {
  source         = "./modules/route53"
  hosted_zone_id = var.hosted_zone_id
  domain_name    = var.domain_name
  alb_dns_name   = module.alb.alb_dns_name
  alb_zone_id    = module.alb.alb_zone_id
}

module "asg_metabase" {
  source     = "./modules/asg_metabase"
  ami_id     = var.ami_id
  instance_type = var.instance_type
  subnet_ids = module.vpc.public_subnet_ids
  key_name   = var.key_name
  vpc_id     = module.vpc.vpc_id
  sg_name    = "metabase-sg"
  user_data_script = var.user_data_script
}

