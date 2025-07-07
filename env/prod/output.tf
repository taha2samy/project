output "prod_vpc_id" {
  value = module.prod_network.vpc_id
}

output "prod_public_subnet_ids" {
  value = module.prod_network.public_subnet_ids
}

output "prod_ec2_public_ips" {
  value = module.prod_compute.ec2_public_ips
}

output "key_private_key_pem" {
  value     = module.key_pair.ec2_private_key_pem
  sensitive = true
}
