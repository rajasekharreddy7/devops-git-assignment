
output "vpc_id" {
  description = "ID of the ecommerce VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = module.vpc.public_subnet_id
}

output "security_group_id" {
  description = "ID of the ecommerce EC2 security group"
  value       = module.security_group.security_group_id
}

output "ec2_public_ip" {
  description = "Public IP of the ecommerce EC2 instance"
  value       = module.ec2.public_ip
}