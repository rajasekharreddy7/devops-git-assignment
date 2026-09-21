variable "vpc_id" {
  description = "VPC ID where the security group will be created"
  type        = string
}

variable "security_group_name" {
  description = "Name of the security group"
  type        = string
}