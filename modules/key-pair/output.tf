output "aws_key_pair" {
  description = "The name of the AWS key pair"
  value       = aws_key_pair.ec2_key_pair.key_name
  
}