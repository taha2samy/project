provider "aws" {
  region = var.aws_region
  
}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
data "aws_ami" "latest_amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
module "prod_network" {
  source = "../../modules/network"

  env                = "prod"
  vpc_cidr_block     = var.prod_vpc_cidr
  public_subnet_cidrs = var.prod_public_subnet_cidrs
  availability_zones = ["${var.aws_region}a", "${var.aws_region}b"] 
}

module "prod_compute" {
  source = "../../modules/compute"

  env                 = "prod"
  vpc_id              = module.prod_network.vpc_id
  public_subnet_ids   = module.prod_network.public_subnet_ids
  instance_count      = var.prod_instance_count
  ami_id              = data.aws_ami.latest_amazon_linux.id
  key_name            = var.prod_key_name
  instance_type       = "t2.micro"
}

module "prod_logging" {
  source = "../../modules/logging"

  env    = "prod"
  vpc_id = module.prod_network.vpc_id
}

