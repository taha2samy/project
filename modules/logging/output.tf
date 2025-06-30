# modules/logging/outputs.tf

output "s3_bucket_name" {
  description = "The name of the S3 bucket for flow logs."
  value       = aws_s3_bucket.flow_logs_bucket.bucket
}

output "cloudwatch_log_group_name" {
  description = "The name of the CloudWatch Log Group for flow logs."
  value       = aws_cloudwatch_log_group.flow_logs_log_group.name
}