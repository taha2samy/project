output "prod_vpc_id" {
  value = module.prod_network.vpc_id
}

output "prod_public_subnet_ids" {
  value = module.prod_network.public_subnet_ids
}

output "prod_ec2_public_ips" {
  value = module.prod_compute.ec2_public_ips
}

output "prod_flow_logs_s3_bucket" {
  value = module.prod_logging.s3_bucket_name
}

output "prod_flow_logs_cloudwatch_log_group" {
  value = module.prod_logging.cloudwatch_log_group_name
}