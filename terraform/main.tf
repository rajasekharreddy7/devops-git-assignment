terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  required_version = ">= 1.15.0"
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = "10.0.1.0/24"
  availability_zone  = "ap-south-2a"
}

module "security_group" {
  source              = "./modules/security-group"
  vpc_id              = module.vpc.vpc_id
  security_group_name = "ecommerce-ec2-sg"
}

module "ec2" {
  source            = "./modules/ec2"
  ami_id            = data.aws_ami.ubuntu.id
  instance_type     = "t3.micro"
  subnet_id         = module.vpc.public_subnet_id
  security_group_id = module.security_group.security_group_id
  key_name          = aws_key_pair.ecommerce.key_name
  instance_name     = "ecommerce-server"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "ecommerce" {
  key_name   = "ecommerce-key"
  public_key = file("C:/Users/lavan/.ssh/id_ed25519.pub")

  tags = {
    Name = "ecommerce-key"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = module.vpc.vpc_id

  tags = {
    Name = "ecommerce-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = module.vpc.vpc_id

  tags = {
    Name = "ecommerce-public-rt"
  }
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public" {
  subnet_id      = module.vpc.public_subnet_id
  route_table_id = aws_route_table.public.id
}
