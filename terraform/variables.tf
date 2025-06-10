variable "ami_id" {
  description = "AMI ID for EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "Instance type for EC2"
  type        = string
}

variable "key_name" {
  description = "Name of the existing EC2 Key Pair"
  type        = string
}

variable "domain_name" {
  description = "Root domain name"
  type        = string
}

variable "db_username" {
  description = "Database master username"
  type        = string
}

variable "db_password" {
  description = "Database master password"
  type        = string
  sensitive   = true
}

variable "project_name" {
  description = "Project prefix for resources"
  type        = string
}

variable "user_data_script" {
  description = "Path to the user data script"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "sg_name" {
  description = "Security group name for Metabase"
  type        = string
}
