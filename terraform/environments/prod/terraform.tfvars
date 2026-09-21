environment = "prod"
aws_region  = "ap-south-2"

vpc_cidr           = "10.20.0.0/16"
public_subnet_cidr = "10.20.1.0/24"
availability_zone  = "ap-south-2a"

instance_type = "t3.micro"

security_group_name = "ecommerce-prod-sg"
instance_name       = "ecommerce-prod-server"

key_name        = "ecommerce-prod-key"
public_key_path = "C:/Users/lavan/.ssh/id_ed25519.pub"