output "pre_prod_vpc_id" {
  value = module.pre_prod_network.vpc_id
}

output "pre_prod_public_subnet_ids" {
  value = module.pre_prod_network.public_subnet_ids
}

output "pre_prod_ec2_public_ips" {
  value = module.pre_prod_compute.ec2_public_ips
}

output "ec2_private_key_pem" {
  value = module.key_pair.ec2_private_key_pem
  sensitive = true
  
}