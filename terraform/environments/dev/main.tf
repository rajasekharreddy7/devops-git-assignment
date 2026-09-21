terraform {
  
backend "s3" {
  bucket       = "rajasekhar-ecommerce-terraform-state"
  key          = "ecommerce/dev/terraform.tfstate"
  region       = "ap-south-2"
  use_lockfile = true
}
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
  source = "../../modules/vpc"

  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  availability_zone  = var.availability_zone
}

module "security_group" {
  source = "../../modules/security-group"

  vpc_id              = module.vpc.vpc_id
  security_group_name = var.security_group_name
}

module "ec2" {
  source = "../../modules/ec2"

  ami_id            = data.aws_ami.ubuntu.id
  instance_type     = var.instance_type
  subnet_id         = module.vpc.public_subnet_id
  security_group_id = module.security_group.security_group_id
  key_name          = aws_key_pair.ecommerce.key_name
  instance_name     = var.instance_name
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

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
  key_name   = var.key_name
  public_key = file(var.public_key_path)

  tags = {
    Name = var.key_name
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = module.vpc.vpc_id

  tags = {
    Name = "${var.environment}-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = module.vpc.vpc_id

  tags = {
    Name = "${var.environment}-public-rt"
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