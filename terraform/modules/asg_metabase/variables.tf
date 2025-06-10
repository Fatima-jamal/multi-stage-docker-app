variable "ami_id" {}
variable "instance_type" {}
variable "key_name" {}
variable "vpc_id" {}
variable "subnet_ids" {
  type = list(string)
}
variable "sg_name" {}
variable "target_group_arn" {}
