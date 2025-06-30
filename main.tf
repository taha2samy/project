# envs/pre-prod/main.tf

provider "aws" {
  region = var.aws_region
}
data "aws_ami" "latest_amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
module "pre_prod_network" {
  source = "./modules/network"

  env                = "pre-prod"
  vpc_cidr_block     = var.pre_prod_vpc_cidr
  public_subnet_cidrs = var.pre_prod_public_subnet_cidrs
  # Ensure these AZs are valid for your chosen 'aws_region'
  availability_zones = ["${var.aws_region}a", "${var.aws_region}b"] # Adjust if your region has more/fewer AZs
}

module "pre_prod_compute" {
  source = "./modules/compute"

  env                 = "pre-prod"
  vpc_id              = module.pre_prod_network.vpc_id
  public_subnet_ids   = module.pre_prod_network.public_subnet_ids
  instance_count      = var.pre_prod_instance_count
  ami_id              = data.aws_ami.latest_amazon_linux.id
  key_name            = var.pre_prod_key_name
  instance_type       = "t2.micro" # Fixed as per Free Tier requirement
}

output "pre_prod_vpc_id" {
  value = module.pre_prod_network.vpc_id
}

output "pre_prod_public_subnet_ids" {
  value = module.pre_prod_network.public_subnet_ids
}

output "pre_prod_ec2_public_ips" {
  value = module.pre_prod_compute.ec2_public_ips
}