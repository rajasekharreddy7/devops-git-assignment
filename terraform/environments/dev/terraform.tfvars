environment = "dev"
aws_region  = "ap-south-2"

vpc_cidr           = "10.10.0.0/16"
public_subnet_cidr = "10.10.1.0/24"
availability_zone  = "ap-south-2a"

instance_type = "t3.micro"

security_group_name = "ecommerce-dev-sg"
instance_name       = "ecommerce-dev-server"

key_name        = "ecommerce-dev-key"

ami_id = "ami-001162706032ff3b3"
