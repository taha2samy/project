# modules/network/outputs.tf

output "vpc_id" {
  description = "The ID of the created VPC."
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "List of IDs of the created public subnets."
  value       = aws_subnet.public.*.id
}

output "public_subnet_cidrs_output" {
  description = "List of CIDR blocks of the created public subnets."
  value       = aws_subnet.public.*.cidr_block
}