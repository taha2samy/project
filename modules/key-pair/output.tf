output "key_name" {
  description = "The name of the AWS key pair"
  value       = aws_key_pair.ec2_key_pair.key_name
  
}

output "ec2_private_key_pem" {
  value     = tls_private_key.ec2_key.private_key_pem
  sensitive = true
}
