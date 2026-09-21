output "vpc_id" {
  description = "PROD VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnet_id" {
  description = "PROD public subnet ID"
  value       = module.vpc.public_subnet_id
}

output "security_group_id" {
  description = "PROD security group ID"
  value       = module.security_group.security_group_id
}

output "ec2_public_ip" {
  description = "PROD EC2 public IP"
  value       = module.ec2.public_ip
}