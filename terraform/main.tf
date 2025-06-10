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

module "ec2" {
  source              = "./modules/ec2"
  project_name        = var.project_name
  sg_id               = module.security_groups.ec2_sg_id
  user_data_script    = "${path.module}/modules/ec2/user_data.sh"
  public_subnet_ids   = module.vpc.public_subnet_ids
  ami_id              = "ami-09f41acd0c74c597b"
  instance_type       = "t3.micro"
}

module "asg" {
  source              = "./modules/asg"
  launch_template_id  = module.ec2.launch_template_id
  subnet_ids          = module.vpc.public_subnet_ids
  alb_sg_id           = module.security_groups.alb_sg_id
}

module "alb" {
  source         = "./modules/alb"
  subnet_ids     = module.vpc.public_subnet_ids
  alb_sg_id      = module.security_groups.alb_sg_id
  target_sg_id   = module.security_groups.ec2_sg_id
  target_port    = 80
  vpc_id         = module.vpc.vpc_id
}

module "bi_ec2" {
  source        = "./modules/bi_ec2"
  ami_id        = "ami-09f41acd0c74c597b"
  instance_type = "t3.micro"
  subnet_id     = module.vpc.public_subnet_ids[0]
  vpc_id        = module.vpc.vpc_id
  key_name      = "FJMS"
}

module "rds_sg" {
  source              = "./modules/rds_sg"
  vpc_id              = module.vpc.vpc_id
  allowed_sg_ids      = [
    module.security_groups.ec2_sg_id,
    module.bi_ec2.metabase_sg_id
  ]
  private_subnet_a_id = module.vpc.private_subnet_a_id
  private_subnet_b_id = module.vpc.private_subnet_b_id
}

module "rds" {
  source              = "./modules/rds"
  vpc_id              = module.vpc.vpc_id
  private_subnet_a_id = module.vpc.private_subnet_a_id
  private_subnet_b_id = module.vpc.private_subnet_b_id
  postgres_sg_id      = module.rds_sg.postgres_sg_id
  mysql_sg_id         = module.rds_sg.mysql_sg_id
  db_username         = "postgresadmin"
  db_password         = "StrongPassword123!"
}

module "route53" {
  source       = "./modules/route53"
  domain_name  = "fatima.jamal.com"
  alb_dns_name = module.alb.alb_dns_name
  alb_zone_id  = module.alb.alb_zone_id
}
