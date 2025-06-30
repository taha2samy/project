
output "ec2_public_ips" {
  description = "List of Public IPs of the provisioned EC2 instances."
  value       = aws_instance.app_server.*.public_ip
}

output "ec2_security_group_id" {
  description = "The ID of the EC2 Security Group."
  value       = aws_security_group.ec2_sg.id
}