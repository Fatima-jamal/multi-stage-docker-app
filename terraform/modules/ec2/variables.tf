variable "project_name" {
  description = "Project name for resource tagging"
  type        = string
}

variable "sg_id" {
  description = "Security group ID to attach to EC2"
  type        = string
}

variable "user_data_script" {
  description = "Path to user data script file"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs to deploy EC2 into"
  type        = list(string)
}

variable "ami_id" {
  description = "AMI ID for EC2 launch template"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}
