output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.ecommerce.id
}

output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.ecommerce.public_ip
}