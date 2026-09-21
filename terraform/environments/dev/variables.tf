variable "environment" {
  description = "Environment name"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
}

variable "availability_zone" {
  description = "Availability zone for the public subnet"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "security_group_name" {
  description = "Security group name"
  type        = string
}

variable "instance_name" {
  description = "EC2 instance name"
  type        = string
}

variable "key_name" {
  description = "AWS EC2 key pair name"
  type        = string
}

variable "public_key_path" {
  description = "Path to the SSH public key"
  type        = string
}